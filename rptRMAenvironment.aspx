<%--
'------------------------------------------------------------------------------------------------------------------------
'Copyright Compal Electronics. All rights reserve.    
'Name: rptRMAenvironment.apsx   Description: rptRMAenvironment
'Purpose:RMA Environment
'Revision: 1.00     Created Date: 2024/10/07     By: Lulu     
'------------------------------------------------------------------------------------------------------------------------
--%>

<%@ Page Title="" Language="VB" MasterPageFile="~/MasterPage.master" AutoEventWireup="false" CodeFile="rptRMAenvironment.aspx.vb" Inherits="r_RMAEnvironment_report" %>
<%@ Register Assembly="DevExpress.Web.v12.2, Version=12.2.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxLoadingPanel" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v12.2, Version=12.2.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxPopupControl" TagPrefix="dx" %>
<%@ Register Assembly="OMSLib" Namespace="OMSLib.WebControls" TagPrefix="cc1" %>
<%@ Register Assembly="DevExpress.Web.v12.2, Version=12.2.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxHiddenField" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v12.2, Version=12.2.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxGridView.Export" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v12.2, Version=12.2.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxGridView" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v12.2, Version=12.2.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxEditors" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v12.2, Version=12.2.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxNavBar" TagPrefix="dx" %>
<%@ Register Assembly="DevExpress.Web.v12.2, Version=12.2.12.0, Culture=neutral, PublicKeyToken=b88d1754d700e49a" Namespace="DevExpress.Web.ASPxUploadControl" TagPrefix="dx" %>

<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="Server">

    <script type="text/javascript">
        function ResultGridViewBind() {
            gvwResult.PerformCallback('databind');
            PopupCreate.Hide();
        }

        function ExcelbtnBind() {
            if (gvwResult.GetVisibleRowsOnPage() > 0) {
                btnExcelDown.SetEnabled(true);
                cbbExpType.SetEnabled(true);
            }
            else {
                btnExcelDown.SetEnabled(false);
                cbbExpType.SetEnabled(false);
            }
        }


        function alertmsg(Message) {
            alert(Message);
        }
    </script>


    <dx:ASPxPopupControl ID="PopupCreate" runat="server" AllowDragging="true" AllowResize="false"
        CloseAction="CloseButton" ClientInstanceName="PopupCreate" Modal="True"
        PopupHorizontalAlign="WindowCenter" PopupVerticalAlign="WindowCenter"
        ContentUrl="~/r_IMEXReport/APAC_rptInvoiceDetail.aspx" HeaderText="Invoice Packing"
        Width="700px" Height="420px" ShowPageScrollbarWhenModal="true">
    </dx:ASPxPopupControl>

    <dx:ASPxNavBar ID="NavBar" runat="server" Width="100%">
        <Groups>
            <dx:NavBarGroup Name="NavQuery" Expanded="true">
                <ContentTemplate>
                    <asp:UpdatePanel ID="UpdatePanelQuery" runat="server">
                        <ContentTemplate>
                            <table>
                                <tr>
                                    <td class="LabelClass">
                                        <dx:ASPxLabel ID="lbPO" runat="server" Text="PO:"></dx:ASPxLabel>
                                    </td>
                                     <td>
                                        <dx:ASPxTextBox ID="txtPO" runat="server" Width="147px" />
                                    </td>
                                    <td class="LabelClass" style="width: 50px">
                                        <dx:ASPxLabel ID="lblRMA" runat="server" Text="RMA#:"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="txtRMA" runat="server" Width="147px" />
                                    </td>
                                  
                                    <td>
                                        <dx:ASPxButton ID="btnQuery" runat="server" Text="Query">
                                            <ClientSideEvents Click="function(s, e) {LoadingPanel.Show();}" />
                                        </dx:ASPxButton>
                                        <asp:Label ID="lblErrorMessage" runat="server" ForeColor="Red" Visible="False" />
                                    </td>
                                </tr>
                                <tr>
                                    <td class="LabelClass">
                                        <dx:ASPxLabel ID="lblStartDate" ClientInstanceName="txtStartDate" runat="server" Text="PO Date:">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxDateEdit ID="txtStartDate" runat="server" Width="147px" 
                                           DisplayFormatString ="yyyy/MM/dd" AllowUserInput="true" AllowNull="true" EditFormatString="yyyy/MM/dd">     
                                        </dx:ASPxDateEdit>

                                    </td>
                                    <td class="LabelClass" style="width: 50px">
                                        <dx:ASPxLabel ID="lblEndDate" runat="server" Text="~">
                                        </dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxDateEdit ID="txtEndDate" runat="server" Width="147px"  AllowUserInput="true" AllowNull="true"
                                             DisplayFormatString="yyyy/MM/dd" EditFormatString="yyyy/MM/dd">                 
                                        </dx:ASPxDateEdit>

                                    </td>
                                </tr>
                                <tr>
                                    <td class="LabelClass">
                                           <dx:ASPxLabel ID="lblHAWB" runat="server" Text="KBB_HAWB:"></dx:ASPxLabel>
                                    </td>
                                    <td>
                                        <dx:ASPxTextBox ID="txtHAWB" runat="server" Width="147px" />
                                    </td> 
                                </tr>                     
                            </table>
                        </ContentTemplate>
                        <Triggers>
                            <asp:AsyncPostBackTrigger ControlID="btnQuery" />
                        </Triggers>
                    </asp:UpdatePanel>
                </ContentTemplate>
                <HeaderTemplate>
                    <dx:ASPxLabel ID="lblQuery" runat="server" Text="RMA enhancement"></dx:ASPxLabel>
                </HeaderTemplate>
                <HeaderTemplateCollapsed>
                    <dx:ASPxLabel ID="lblCQuery" runat="server" Text="RMA enhancement"></dx:ASPxLabel>
                </HeaderTemplateCollapsed>
            </dx:NavBarGroup>
            <dx:NavBarGroup Name="NavResult" Expanded="true">
                <ContentTemplate>
                    <asp:UpdatePanel ID="UpdatePanelResult" runat="server">
                        <ContentTemplate>
                            <table>
                                <tr>
                                    <td>
                                       <dx:ASPxComboBox ID="cbbExpType" runat="server" ClientInstanceName="cbbExpType" ValueType="System.String" Width="100px">
                                            <Items>
                                                <dx:ListEditItem Text="EXCEL 2010" Value="xlsx" Selected="True" />
                                                <dx:ListEditItem Text="EXCEL 2003" Value="xls" />
                                                <dx:ListEditItem Text="CSV File" Value="Csv" />
                                                <dx:ListEditItem Text="PDF File" Value="PDF" />
                                                <dx:ListEditItem Text="RTF File" Value="Rtf" />
                                            </Items>
                                        </dx:ASPxComboBox>
                                    </td>
                                     <td>
                                        <dx:ASPxButton ID="btnExcelDown" ClientInstanceName="btnExcelDown" runat="server" Text="Export" OnClick="btnExcelDown_Click">
                                        </dx:ASPxButton>
                                    </td>
                                </tr>
                            </table>
                            <table>
                                <tr>
                                    <td colspan="3">
                                        <dx:ASPxGridView ID="gvwResult" runat="server" AutoGenerateColumns="False"
                                            DataSourceID="DSgvwResult" KeyFieldName="PO; RMA; HAWB" ClientInstanceName="gvwResult"
                                            OnCustomCallback="gvwResult_CustomCallback" 
                                            SettingsBehavior-AllowDragDrop="false"
                                            SettingsBehavior-AllowGroup="false" Settings-ShowFilterBar="Hidden">
                                            <SettingsPager Mode="ShowAllRecords" />
                                            <SettingsBehavior AllowFocusedRow="True" />
                                           <ClientSideEvents Init="function(s,e){ ExcelbtnBind() }" />
                                            <Columns>
                                                <dx:GridViewDataTextColumn FieldName="RMA_NO" VisibleIndex="0" Caption="RMA#" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"><HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="PONO" VisibleIndex="1" Caption="PO#" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"><HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="PODATE" VisibleIndex="2" Caption="PO Date" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"><HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="KBB_HAWB" VisibleIndex="3" Caption="KBB HAWB" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"><HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="POLINE" VisibleIndex="4" Caption="PO Line" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"><HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="PRODIDDESC1" VisibleIndex="5" Caption="KGB MPN" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"><HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="KGB91" VisibleIndex="5" Caption="KGB 91J" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"><HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="PRODIDDESC2" VisibleIndex="6" Caption="KBB MPN" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"><HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="KBB77" VisibleIndex="6" Caption="KGB 77" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"><HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="CUSTMODEL" VisibleIndex="7" Caption="Model" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"><HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="QUANTITY" VisibleIndex="8" Caption="QTY" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"><HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="RMA_MES1" VisibleIndex="9" Caption="RMA MES1" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"><HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="RMA_QAD1" VisibleIndex="10" Caption="RMA QAD1" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"><HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="RMA_SHIPTYPE" VisibleIndex="11" Caption="Book" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"><HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="RMA_REGIONFROM" VisibleIndex="11" Caption="RMA From" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"><HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewDataTextColumn>
                                                <dx:GridViewDataTextColumn FieldName="RMA_REGIONTO" VisibleIndex="11" Caption="RMA To" ReadOnly="True" HeaderStyle-HorizontalAlign="Center"><HeaderStyle HorizontalAlign="Center" />
                                                </dx:GridViewDataTextColumn>
                                               
                                            </Columns>
                                        </dx:ASPxGridView>
                                    </td>
                                </tr>
                                
                            </table>
                         </ContentTemplate>
                        <Triggers>
                            <asp:PostBackTrigger ControlID="btnExcelDown" />
                        </Triggers>
                    </asp:UpdatePanel>
                    <dx:ASPxGridViewExporter ID="gvExport" runat="server" GridViewID="gvwResult" OnRenderBrick="gvExport_RenderBrick">
                    </dx:ASPxGridViewExporter>      
                </ContentTemplate>
                <HeaderTemplate>
                    <dx:ASPxLabel ID="lblResult" runat="server" Text="Result"></dx:ASPxLabel>
                </HeaderTemplate>
                <HeaderTemplateCollapsed>
                    <dx:ASPxLabel ID="ASPxLabel1" runat="server" Text="Result"></dx:ASPxLabel>
                </HeaderTemplateCollapsed>
            </dx:NavBarGroup>
        </Groups>
    </dx:ASPxNavBar>
    <cc1:OSQLDataSource ID ="DSgvwResult" runat="server"
        ConnectionString="<%$ ConnectionStrings:OMSConnection %>"
        ProviderName="<%$ ConnectionStrings:OMSConnection.ProviderName %>">
    </cc1:OSQLDataSource>
</asp:Content>
