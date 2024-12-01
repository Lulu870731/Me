'------------------------------------------------------------------------------------------------------------------------
'Copyright Compal Electronics. All rights reserved.    
'Name: rptRMAenvironment.apsx.vb   Description: rptRMAenvironment 
'Purpose:rptRMAenvironment 
'Revision: 1.00     Created Date: 2024/10/07     By: Lulu    
'------------------------------------------------------------------------------------------------------------------------

Imports OMSLib
Imports OMSLib.OLibFunc
Imports System.Data
Imports DevExpress.Web.ASPxEditors
Imports DevExpress.Web.ASPxGridView
Imports DevExpress.Web.ASPxHiddenField
Imports DevExpress.Web.ASPxGridView.Export
Imports System.IO
Imports NPOI.SS.UserModel
Imports NPOI.HSSF.UserModel
Imports NPOI.HSSF.Util
Imports NPOI.SS.Util
Imports System.Web.Configuration
Imports Oracle.DataAccess.Client

Partial Class r_RMAEnvironment_report
    Inherits OBaseForm

    Protected Sub gvwResult_CustomCallback(ByVal sender As Object, ByVal e As DevExpress.Web.ASPxGridView.ASPxGridViewCustomCallbackEventArgs) Handles gvwResult.CustomCallback
        If (e.Parameters = "databind") Then
            sender.DataBind()
        End If
    End Sub
    Protected Sub btnExcelDown_Click(sender As Object, e As EventArgs)
        Dim type As String = CType(NavBar.Groups.Item(1).FindControl("cbbExpType"), ASPxComboBox).Value.ToString()
        Dim export As ASPxGridViewExporter = NavBar.Groups.Item(1).FindControl("gvExport")

        Select Case type
            Case "xlsx"
                export.WriteXlsxToResponse()
            Case "xls"
                export.WriteXlsToResponse()
            Case "Csv"
                export.WriteCsvToResponse()
            Case "PDF"
                export.WritePdfToResponse()
            Case "Rtf"
                export.WriteRtfToResponse()
        End Select
    End Sub

    'Protected Sub btnExcelDown_Click(sender As Object, e As EventArgs) Handles btnExcelDown.Click
    '    Dim oExporter As ASPxGridViewExporter = NavBar.Groups.Item(1).FindControl("gvwExporter")
    '    Dim sExpType As String = CType(NavBar.Groups.Item(1).FindControl("UpdatePanelResult").FindControl("cbbExpType"), ASPxComboBox).Value
    '    Select Case sExpType
    '        Case "xlsx"
    '            oExporter.WriteXlsxToResponse()
    '        Case "xls"
    '            oExporter.WriteXlsToResponse()
    '        Case "Csv"
    '            oExporter.WriteCsvToResponse()
    '        Case "PDF"
    '            oExporter.WritePdfToResponse()
    '        Case "Rtf"
    '            oExporter.WriteRtfToResponse()
    '    End Select
    'End Sub
   
    Protected Sub btnQuery_Click(sender As Object, e As EventArgs) Handles btnQuery.Click
        Dim sSQL As String = String.Empty
        Dim err As String = String.Empty
        Dim sWhere As String = String.Empty
        Dim sPO As String = txtPO.Text.Trim()
        Dim sRMA As String = txtRMA.Text.Trim()
        Dim sHawb As String = txtHAWB.Text.Trim()
        Dim dateFrom As String = CType(NavBar.Groups.Item(0).FindControl("txtStartDate"), ASPxDateEdit).Text
        Dim dateTo As String = CType(NavBar.Groups.Item(0).FindControl("txtEndDate"), ASPxDateEdit).Text
        'Dim sPODate As String = String.Empty
        Dim ds As DataSet = Nothing
        Dim sConstr As String = ConfigurationManager.ConnectionStrings("OMSConnection").ConnectionString
        Dim gvwResult As ASPxGridView = CType(NavBar.Groups.Item(1).FindControl("UpdatePanelResult").FindControl("gvwResult"), ASPxGridView)

        Try
          
            If String.IsNullOrWhiteSpace(txtPO.Text) AndAlso
            String.IsNullOrWhiteSpace(txtRMA.Text) AndAlso
            String.IsNullOrWhiteSpace(txtHAWB.Text) AndAlso
            (String.IsNullOrWhiteSpace(dateFrom) OrElse String.IsNullOrWhiteSpace(dateTo)) Then

                lblErrorMessage.Text = "please answer full search information！"
                lblErrorMessage.Visible = True
                Return
            End If

            lblErrorMessage.Visible = False
            sWhere = ""
            If Not String.IsNullOrWhiteSpace(txtPO.Text) Then
                sWhere += " and  pom.pono='" & sPO & "'"
            End If

            If Not String.IsNullOrWhiteSpace(txtRMA.Text) Then
                sWhere += " and  pom.rma_no='" & sRMA & "'"
            End If

            If Not String.IsNullOrWhiteSpace(txtHAWB.Text) Then
                sWhere += " and  pom.kbb_hawb='" & sHawb & "'"
            End If

            If Not String.IsNullOrEmpty(dateFrom) AndAlso Not String.IsNullOrEmpty(dateTo) Then
                sWhere += " AND pom.CREATEDDATE BETWEEN TO_DATE('" & dateFrom & "', 'yyyy/MM/dd') AND TO_DATE('" & dateTo & "', 'yyyy/MM/dd')"
            End If

            sSQL = "select pom.rma_no,pom.pono,pom.kbb_hawb,to_char(CREATEDDATE,'yyyy-mm-dd hh24:mi:ss') podate, " +
                   "       pd.poline,pd.PRODIDDESC1,pd.PRODIDDESC2,pd.QUANTITY,pd.rma_mes1,pd.rma_qad1,pd.rma_shiptype book,pd.rma_regionfrom,pd.rma_regionto," +
                   "       pop.kgb91,pop.KBB77,pm.custmodel,pd.RMA_SHIPTYPE" +
                   "  from pomaster pom " +
                   "  join podetail pd on pd.pono=pom.pono " +
                   "  join popart pop on pop.pono=pd.pono " +
                   "  left join partmapping pp on pp.rma_type = pd.rma_type and pp.custpart = pd.prodiddesc1 " +
                   "  join partmstr pm on pm.part = pp.ccipart"

            sSQL += " Where 1 = 1 "

            If sWhere <> "" Then
                sSQL += sWhere
            End If

            DSgvwResult.SelectCommand = sSQL
            ' 設定參數化的查詢以避免 SQL 注入
            DSgvwResult.SelectParameters.Clear()
            gvwResult.DataBind()
           
            ' 清除錯誤消息
            lblErrorMessage.Visible = False
        Catch ex As Exception
            ' 處理異常
            lblErrorMessage.Text = "查詢發生錯誤: " & ex.Message
            lblErrorMessage.Visible = True
        End Try
    End Sub
    Protected Sub gvExport_RenderBrick(sender As Object, e As ASPxGridViewExportRenderingEventArgs)
        If e.RowType = GridViewRowType.Header Then
            If e.Text.Contains("<br>") Then
                e.TextValue = e.Text.Replace("<br>", " ")
            End If
        ElseIf e.RowType = GridViewRowType.Data Then
            If e.Text.Contains("<br>") Then
                e.TextValue = e.Text.Replace("<br>", Environment.NewLine)
            End If
        End If
    End Sub
End Class