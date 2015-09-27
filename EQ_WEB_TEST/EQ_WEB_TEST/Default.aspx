<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default.aspx.cs" Inherits="QueryMainForm" EnableSessionState="True" Trace="False" EnableEventValidation = "False" %>

<!-- Register Assembly="System.Web.Extensions, Version=1.0.61025.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35"
    Namespace="System.Web.UI" TagPrefix="asp" -->

<%@ Register Assembly="Korzh.EasyQuery.WebControls.NET20" Namespace="Korzh.EasyQuery.WebControls"
    TagPrefix="keqwc" %>

<!DOCTYPE html>
  
<html xmlns="http://www.w3.org/1999/xhtml">
	<head runat="server"> 
		<meta name="vs_snapToGrid" content="True" />
        <meta name="viewport" content="width=device-width, initial-scale=1" />
		<title>EasyQuery.NET - ad-hoc query builder for ASP.NET web-sites. Demo page.</title>
		<meta content="C#" name="CODE_LANGUAGE" />
		<meta content="JavaScript" name="vs_defaultClientScript" />
		<meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
        <link href="StyleSheet.css" rel="stylesheet" type="text/css" />
        <style type="text/css">
          A:link { color:#006699 }
          A:active { color:#FF0000 }
          A:visited { color:#006699 }
          
          td.leftCol{
            background-color:#FFFFFF;
            border-color:#4B9EDC;
            border-style:solid;
            border-width:4px 1px 4px 4px;
            vertical-align:top;
            padding: 4px;
          }

          td.rightCol{
            background-color:#FFFFFF;
            border-color:#4B9EDC;
            border-style:solid;
            border-width:4px 4px 4px 1px;
          }
          
        </style>
    </head>
<body>
		
<form id="Form1" method="post" runat="server">
<asp:ScriptManager ID="ScriptManager1" runat="server" />
<table style="width:100%;border:0" id="table1" cellspacing="0" cellpadding="5">
	<tbody>
	<tr>

		<td style="background-color:#F0F0F0;">
		<div class="header">
			<table style="width:100%;border:0" cellspacing="0" cellpadding="0">
				<tbody>
				<tr>
					<td>
					<img style="border:0" src="images/logo_ico.jpg" alt="title"/></td>
					<td style="width:100%">

						<table cellspacing="0" cellpadding="0" style="width:100%;border:0">
						    <tr>
						        <td>
	    					        <h1 class="title0">
    					            <asp:Literal ID="txtTitle" runat="server" Text="<%$ Resources:txtTitle%>" /> 
    					            </h1>
    						    </td>
    						    <td style="vertical-align:top; text-align:right;">
                                    <asp:LinkButton ID="lnkBtnEng" runat="server" CommandName="LangSwitch" CommandArgument="en-US" OnCommand="LangSwitch_Command">English</asp:LinkButton> | 
                                    <asp:LinkButton ID="lnkBtnUkr" runat="server" CommandName="LangSwitch" CommandArgument="uk-UA" OnCommand="LangSwitch_Command">Ukrainian</asp:LinkButton> |
                                    <asp:LinkButton ID="lnkBtnEsp" runat="server" CommandName="LangSwitch" CommandArgument="es-ES" OnCommand="LangSwitch_Command">Spanish</asp:LinkButton>
                                </td>
						    </tr>
                            <tr>
                                <td style="text-align:left; height: 18px;">
					            <h2 class="subTitle">
					            <asp:Literal ID="txtSubTitle" runat="server" Text="<%$ Resources:txtSubTitle%>" /> 
				                </h2>                                
                                </td>
                                <td style="text-align:right; height: 18px;">
                                    <asp:Label ID="LabelVersion" runat="server" Font-Names="Verdana,Arial" Font-Size="Smaller"></asp:Label>
                                </td>
                            </tr>
                        </table>
					</td>
				</tr>
			</tbody>
			</table>
		</div>
		</td>
	</tr>
</tbody>
</table>
<asp:Label ID="ErrorLabel" runat="server" Text="______" Font-Bold="True" ForeColor="Red" Visible="False"></asp:Label>
<table style="width:100%;border:0" cellpadding="0" cellspacing="5" id="table17">
	<tbody>
	<tr>
		<td style="width:75%;vertical-align:top">
		<table style="width:100%;border:0" cellpadding="0" cellspacing="0" id="table18">
			<tbody>
			<tr>

				<td style="background-color:#4B9EDC" colspan="2">
						<table style="border:0;width:100%" cellspacing="0" cellpadding="0">
						<tr>
						<td class="title1">
						<asp:Literal ID="txtQueryDef" runat="server" Text="<%$ Resources:txtQueryDef%>" /> 
						</td>
						<td style="background-color:#FFFFFF;text-align:right;vertical-align:top">
                            <asp:UpdateProgress ID="UpdateProgressColumns" runat="server" AssociatedUpdatePanelID="UpdatePanelColumns">
                                <ProgressTemplate>
                                    <span style="font-weight:bold;font-size:14px">Processing... </span>
                                    <img src="images/progressBar2.gif" alt="Progress Bar"/>
                                </ProgressTemplate>
                            </asp:UpdateProgress>
                            <asp:UpdateProgress ID="UpdateProgressConditions" runat="server" AssociatedUpdatePanelID="UpdatePanelConditions">
                                <ProgressTemplate>
                                    <span style="font-weight:bold;font-size:14px">Processing... </span>
                                    <img src="images/progressBar2.gif" alt="Progress Bar" /> 
                                </ProgressTemplate>
                            </asp:UpdateProgress>
						</td>
						</tr>
						</table>
				</td>
			</tr>
			<tr>
			    <td style="width:180px;height: 383px;" class="leftCol">
					<asp:UpdatePanel ID="UpdatePanelEntities" runat="server">
                    <ContentTemplate>
                        <div class="title2">
                        <asp:Literal ID="Literal2" runat="server" Text="<%$ Resources:txtEntAttr%>" /> 
                        </div>
                        <keqwc:EntitiesPanel ID="EntitiesPanel1" runat="server" Width="100%" Height="360px" BorderStyle="Solid" CssClass="bodytext" ToolTip="Entities and attributes">
                        </keqwc:EntitiesPanel>							
                    </ContentTemplate>
                    </asp:UpdatePanel>
			    </td>
				<td style="height: 383px;" class="back_blue rightCol">
				    <table style="width:100%;border:0" id="table19" cellspacing="0" cellpadding="0">

					<tbody>
					<tr>
						<td style="vertical-align:top">
						<asp:UpdatePanel ID="UpdatePanelColumns" runat="server">
                            <ContentTemplate>
                            
                            <table style="width:100%;border:0" cellpadding="2" cellspacing="2">
								<tr>
                                    <td style="width:60%">
                                        <div class="title2">
                                        <asp:Literal ID="txtResultColumns" runat="server" Text="<%$ Resources:txtResultColumns%>" /> 
                                        </div>
                                        <keqwc:QueryColumnsPanel ID="QueryColumnsPanel1" runat="server" Height="150px" Width="100%" BorderStyle="Solid" ShowHeaders="True" CssClass="bodytext" ToolTip="Result Columns">
                                        </keqwc:QueryColumnsPanel>							
                                    </td>
                                    <td>
                                    &nbsp;
                                    </td>
                                    <td>
                                        <div class="title2">
                                        <asp:Literal ID="txtColumnSoring" runat="server" Text="<%$ Resources:txtColumnSorting%>" /> 
                                        </div>
                                        <keqwc:SortColumnsPanel ID="SortColumnsPanel1" runat="server" Height="150px" ToolTip="Columns Sorting" Width="100%">
                                        </keqwc:SortColumnsPanel>
                                    </td>
                                </tr>
                            </table>
                            </ContentTemplate>
                        </asp:UpdatePanel>
						</td>
					
					</tr>
				    </tbody>
				    </table>
				    <table border="0" width="100%" id="table22" cellspacing="2" cellpadding="2">
					<tbody>
					<tr>
						<td>
						<table style="border:0;width:100%" cellspacing="0" cellpadding="0">
						<tr>
						<td class="title2">
						<asp:Literal ID="txtQueryConditions" runat="server" Text="<%$ Resources:txtQueryConditions%>" />
						</td>
						<td>
						</td>
						</tr>
						</table>
						<asp:UpdatePanel ID="UpdatePanelConditions" runat="server">
                                <ContentTemplate>
                            <keqwc:QueryPanel ID="QueryPanel1" runat="server" Height="160px" Width="100%" BorderWidth="1px" ScrollBars="Auto" OnSqlExecute="QueryPanel1_SqlExecute" CssClass="bodytext" OnListRequest="QueryPanel1_ListRequest" OnCreateValueElement="QueryPanel1_CreateValueElement" Appearance-ScriptMenuStyle-ItemMinWidth="160" Appearance-ScriptMenuStyle-BackColor="#FFE0C0" UseListCache="True">
                            </keqwc:QueryPanel>
                                </ContentTemplate>
                        </asp:UpdatePanel>
                            &nbsp;
						</td>
					</tr>
				    </tbody>
				    </table>

				</td>
			</tr>
		</tbody>
		</table>
		</td>
		<td valign="top" style="width:320px">

		<table border="0" cellpadding="0" cellspacing="0" width="100%" id="table8">
			<tbody>
			<tr>
				<td style="background-color:#9A90BC">
				<div class="title1">
				<asp:Literal ID="txtOperations" runat="server" Text="<%$ Resources:txtOperations%>" /> 
				</div>
				</td>
			</tr>

			<tr>
				<td align="center" style="background-color:#F8F7FC; border: solid 4px #9A90BC; height:109px; background-image: url(images/back_form.gif);">
				<table id="table12" cellspacing="0" cellpadding="5">
					<tbody>
					<tr>

						<td style="height: 34px"></td>
						<td style="height: 34px">
						<asp:Button ID="btnClear" runat="server" Height="24px" OnClick="ClearBtn_Click" Text="Clear"
                            Width="80px" CssClass="btn" meta:resourcekey="btnClear" />
                        </td>
					</tr>
					<tr>
						<td valign="bottom" style="height: 17px">
						    <div style="text-align: left">
							<asp:Literal ID="txtQueryFile" runat="server" Text="<%$ Resources:txtQueryFile%>" /> 
							</div>
						    <asp:FileUpload ID="SavedQueryUpload" runat="server" Height="20px" />
						</td>

						<td valign="bottom" style="height: 17px">
						<asp:Button ID="btnLoad" runat="server" Height="24px" OnClick="LoadBtn_Click" Text="Load"
                            Width="80px" CssClass="btn"  meta:resourcekey="btnLoad"/>
						</td>
					</tr>
					<tr>
						<td></td>
						<td>
						<asp:Button ID="btnSave" runat="server" Height="24px" OnClick="SaveBtn_Click" Text="Save..."
                            Width="80px" CssClass="btn"  meta:resourcekey="btnSave" />
						</td>
					</tr>
				</tbody>
				</table>
				</td>

			</tr>
		</tbody>
		</table>
		<div>
			<img style="border:0" src="images/t.gif" width="1" height="17" alt="blank"/></div>
		<table border="0" cellpadding="0" cellspacing="0" width="100%" id="table24">
			<tbody>
			<tr>
				<td style="background-color:#FFAD2B;">

				<div class="title1">
					SQL</div>
				</td>
			</tr>
			<tr>
				<td style="background-color:#FFFFFF; border: solid 4px #FFAD2B; height: 102px;">
                    <asp:UpdatePanel ID="UpdatePanel3" runat="server">
                        <ContentTemplate>
                <asp:TextBox ID="SqlTextBox" runat="server"  Width="98%" Height="224px" TextMode="MultiLine"></asp:TextBox>
                        </ContentTemplate>
                    </asp:UpdatePanel>
				</td>
			</tr>
		</tbody>

		</table>
            </td>
	</tr>
	<tr>
		<td valign="top">
        <asp:UpdatePanel ID="UpdatePanel2" runat="server">
        <ContentTemplate>

		<table border="0" cellpadding="0" cellspacing="0" width="100%" id="table29">
			<tbody>
			<tr>
				<td>

                <table border="0" cellpadding="0" cellspacing="0" width="100%">
                <tr>
                <td style="background-color:#00c62c; width: 160px; height: 22px;"> 
				<div class="title1">
				    <asp:Literal ID="txtResult" runat="server" Text="<%$ Resources:txtResult%>" /> 
                </div>
				</td>
				<td style="height: 22px">&nbsp;&nbsp;
                        <asp:Button ID="btnUpdateResult" runat="server" OnClick="UpdateResultBtn_Click" Text="Update Result"
                            Width="112px" Height="20px" CssClass="btn"  meta:resourcekey="btnUpdateResult" />
                            &nbsp;&nbsp;
                        <asp:Button ID="btnExportExcel" runat="server" OnClick="ExportExcelBtn_Click" Text="Export to Excel"
                            Width="112px" Height="20px" CssClass="btn"  meta:resourcekey="btnExportExcel" /></td>
				</tr>
				</table></td>
			</tr>
			<tr>
				<td style="background-color:#FFFFFF; border: solid 4px #00c62c; width: 186px;" class="back_blue">
				<table border="0" width="100%" id="table30" cellspacing="0" cellpadding="0">
					<tbody>

					<tr>
						<td valign="top">
                        <asp:Label ID="ResultLabel" runat="server" Text="Label" Visible="False" Font-Bold="True" ForeColor="Maroon" Height="4px" Width="15px"></asp:Label>
                        <asp:Panel ID="PanelResult" runat="server" Height="200px" Width="100%" ScrollBars="Auto">
                            <asp:GridView ID="ResultGrid" runat="server" DataSourceID="ResultDS" Font-Size="XX-Small" ForeColor="Black" CellPadding="4" GridLines="Vertical" BackColor="White" BorderColor="#DEDFDE" BorderStyle="None" BorderWidth="1px">
                                <RowStyle Font-Size="XX-Small" BackColor="#F7F7DE" />
                                <HeaderStyle Font-Size="X-Small" BackColor="#6B696B" Font-Bold="True" ForeColor="White" />
                                <FooterStyle BackColor="#CCCC99" />
                                <PagerStyle BackColor="#F7F7DE" ForeColor="Black" HorizontalAlign="Right" />
                                <SelectedRowStyle BackColor="#CE5D5A" Font-Bold="True" ForeColor="White" />
                                <AlternatingRowStyle BackColor="White" />
                            </asp:GridView>
                        </asp:Panel>
						
						</td>

					</tr>
				</tbody>
				</table>
				</td>
			</tr>
		</tbody>
		</table>
        </ContentTemplate>
        <Triggers>
           <asp:PostBackTrigger ControlID="btnExportExcel" />
        </Triggers>
		</asp:UpdatePanel>
		</td>
		<td style="vertical-align: top; width: 320px;"> 
		    <table border="0" cellpadding="0" cellspacing="0" width="100%" id="Table2">
            <tr>
                <td style="background-color:#bdb76b">
                    <div class="title1">
      				    <asp:Literal ID="txtQueryDesc" runat="server" Text="<%$ Resources:txtQueryDesc%>" /> 
                    </div>
                </td>
            </tr>
            <tr>
                <td style="border-right: #bdb76b 4px solid; border-top: #bdb76b 4px solid; border-left: #bdb76b 4px solid; border-bottom: #bdb76b 4px solid; height: 208px; vertical-align: top; width:100%">
                <asp:Literal ID="Literal1" runat="server"></asp:Literal><br />&nbsp;
                </td>
            </tr>
        </table>
        </td>
	</tr>

</tbody>
</table>
<hr />
<div>
<h3>
Need similar functionality on your own web-site? Take a look at our <a href="http://devtools.korzh.com/easyquery/">query builder components for ASP.NET</a>. Free demo version!
</h3>
<div style="text-align:center; padding: 10 0 30 0;">
    (c) Copyright 2006-2013. <a href="http://devtools.korzh.com/" target="_blank">Korzh.com</a></div>
           <asp:AccessDataSource ID="ResultDS" runat="server" DataFile="~/App_Data/NWind.mdb"></asp:AccessDataSource>
    &nbsp; &nbsp;
</div>
        </form>			 
	</body>
</html>
