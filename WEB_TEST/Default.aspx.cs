using System;
using System.IO;
using System.Data;
using System.Data.OleDb;
using System.Configuration;
using System.Collections;
using System.Text;
using System.Xml;
using System.Drawing;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Korzh.EasyQuery;
using Korzh.EasyQuery.Db;

public partial class QueryMainForm : System.Web.UI.Page
{
    private System.Data.OleDb.OleDbConnection DbConnection = null;
    //private Korzh.EasyQuery.WebControls.QueryPanel qpanel;

    private string baseDataPath = null;
    private static string appPrefix = "EQN-DEMO-AJAX-";
    private static string querySessionName = appPrefix + "QUERY";
    private static string langSessionName = appPrefix + "LANG";

    private Korzh.EasyQuery.Db.DbQuery query = null;
    
    protected void Page_Init(object sender, EventArgs e) {
        baseDataPath = this.MapPath("./App_Data");
        InitSessionObjects();
    }

    private void InitSessionObjects() {
        query = (Korzh.EasyQuery.Db.DbQuery)Session[querySessionName];

        if (query == null) 
            InitQuery();
        //string path = AppDomain.CurrentDomain.BaseDirectory;
        //path += "data\\nwind1.xml";
    }

    protected override void InitializeCulture() {
        base.InitializeCulture();
        string lang = (string)Session[langSessionName];
        if (lang == null) 
            lang = InitLanguage();

        System.Globalization.CultureInfo ci = new System.Globalization.CultureInfo(lang);
        System.Threading.Thread.CurrentThread.CurrentCulture = ci;
        System.Threading.Thread.CurrentThread.CurrentUICulture = ci;
    }


    private void InitQuery() {
        Korzh.EasyQuery.Db.DbModel model = new Korzh.EasyQuery.Db.DbModel();
        model.UseResourcesForOperators = true;

        string path = System.IO.Path.Combine(baseDataPath, "NWind.xml");
        model.LoadFromFile(path);

        query = new Korzh.EasyQuery.Db.DbQuery();
        //query.Formats.EOL = Korzh.EasyQuery.EOLSymbol.None;
        query.Model = model;
        //query.Formats.AlphaAlias = true;
        query.Formats.SetDefaultFormats(FormatType.MsAccess);
        Session[querySessionName] = query;
    }

    private string InitLanguage() {
        System.Globalization.CultureInfo ci = System.Threading.Thread.CurrentThread.CurrentUICulture;
        string lang = ci.ToString();
        if (lang.Length < 3) { //create the specific culture if the neutral one was passed in request
            lang = System.Globalization.CultureInfo.CreateSpecificCulture(lang).ToString();
        }

        Session[langSessionName] = lang;
        return lang;
    }

    protected void Page_Load(object sender, EventArgs e) {

        if (!Page.IsPostBack) {
            string queryName = Page.Request.QueryString.Get("query");
            if (queryName != null) {
                query.LoadFromFile(baseDataPath + "\\" + queryName + ".xml");
            }
        }

        //query.Model.ReloadResources();
        query.Model.UpdateOperatorsTexts();

        QueryPanel1.Query = query;

        QueryColumnsPanel1.Query = QueryPanel1.Query;
        EntitiesPanel1.Query = QueryPanel1.Query;

        SortColumnsPanel1.Query = QueryPanel1.Query;

        query.ColumnsChanged += new Korzh.EasyQuery.ColumnsChangedEventHandler(query_ColumnsChanged);
        query.ConditionsChanged += new Korzh.EasyQuery.ConditionsChangedEventHandler(query_ConditionsChanged);
        query.SortOrderChanged += new Korzh.EasyQuery.SortOrderChangedEventHandler(query_SortOrderChanged);

        System.Reflection.AssemblyFileVersionAttribute versionAttr =
            (System.Reflection.AssemblyFileVersionAttribute)System.Attribute.GetCustomAttribute(QueryPanel1.GetType().Assembly, typeof(System.Reflection.AssemblyFileVersionAttribute));

        LabelVersion.Text = "Version: " + versionAttr.Version;

        EnableLinkButton(lnkBtnEng);
        EnableLinkButton(lnkBtnUkr);
        EnableLinkButton(lnkBtnEsp);
    }

    private void EnableLinkButton(LinkButton btn) {
        string lang = System.Threading.Thread.CurrentThread.CurrentCulture.ToString();
        if (btn.CommandArgument == lang) {
            btn.ForeColor = Color.Black;
            btn.Font.Bold = true;
            btn.Font.Underline = false;
            btn.OnClientClick = "return false";
        }
        else {
            btn.ForeColor = Color.Empty;
            btn.Font.Bold = false;
            btn.Font.Underline = true;
            btn.OnClientClick = "";
        }
    }

    protected void Page_Unload(object sender, EventArgs e) {
        QueryPanel1.Query.ColumnsChanged -= new Korzh.EasyQuery.ColumnsChangedEventHandler(query_ColumnsChanged);
        QueryPanel1.Query.ConditionsChanged -= new Korzh.EasyQuery.ConditionsChangedEventHandler(query_ConditionsChanged);
        QueryPanel1.Query.SortOrderChanged -= new Korzh.EasyQuery.SortOrderChangedEventHandler(query_SortOrderChanged);
    }

    protected void LoadBtn_Click(object sender, EventArgs e)
    {
        if (SavedQueryUpload.HasFile) {
            try {
                // Initialize the reader.
                System.IO.TextReader reader = new StreamReader(SavedQueryUpload.PostedFile.InputStream);
                
                // Copy the byte array into a string.
                string QueryText = reader.ReadToEnd();

                reader.Close();
                
                QueryPanel1.Query.LoadFromString(QueryText);
            }
            catch (Exception ex) {
                ErrorLabel.Text = "Error during loading: " + ex.Message;
                ErrorLabel.Visible = true;
            }
        }
    }
    protected void SaveBtn_Click(object sender, EventArgs e)
    {
        Response.ClearHeaders();
        Response.ContentType = "text/xml";
        Response.Clear();

        Response.BufferOutput = true;
        Response.AddHeader("Content-Disposition", "attachment;filename=query.xml"); 

        string QueryText = QueryPanel1.Query.SaveToString();
        byte[] output = System.Text.UnicodeEncoding.UTF8.GetBytes(QueryText);

        Response.OutputStream.Write(output, 0, output.GetLength(0));

        Response.End();
    }

    protected void ClearBtn_Click(object sender, EventArgs e)
    {
        QueryPanel1.Query.Clear();
        SqlTextBox.Text = "";
        ResultGrid.Columns.Clear();
    }

    protected void CheckConnection() {
        if (DbConnection == null) {
            DbConnection = new OleDbConnection();
            DbConnection.ConnectionString = "Provider=Microsoft.Jet.OLEDB.4.0;Data Source=" +
               System.IO.Path.Combine(baseDataPath, "Nwind.mdb") + ";Persist Security Info=False";
            DbConnection.Open();
        }
    }
        
    protected void QueryPanel1_SqlExecute(object sender, Korzh.EasyQuery.WebControls.SqlExecuteEventArgs e) {
        CheckConnection();
        OleDbDataAdapter resultDA = new OleDbDataAdapter(e.SQL, DbConnection);

        DataSet tempDS = new DataSet();
        resultDA.Fill(tempDS, "Result");

        StringWriter strWriter = new StringWriter();
        tempDS.WriteXml(strWriter);
        e.ListItems.LoadFromXml(strWriter.ToString());
    }

    protected void QueryPanel1_ListRequest(object sender, Korzh.EasyQuery.WebControls.ListRequestEventArgs e) {
        if (e.ListName == "RegionList") {
            e.ListItems.Add("British Columbia", "BC");
            e.ListItems.Add("Colorado", "CO");
            e.ListItems.Add("Oregon", "OR");
            e.ListItems.Add("Washington", "WA");
        }
    }

    protected void query_ColumnsChanged(object sender, Korzh.EasyQuery.ColumnsChangeEventArgs e) {
        UpdateSql();
    }

    protected void query_ConditionsChanged(object sender, Korzh.EasyQuery.ConditionsChangeEventArgs e) {
        UpdateSql();
    }

    protected void query_SortOrderChanged(object sender, Korzh.EasyQuery.SortOrderChangedEventArgs e) {
        UpdateSql();
    }

    
    protected void UpdateSql() {
        try {
            SqlQueryBuilder builder = new SqlQueryBuilder(query);
            builder.BuildSQL();
            SqlTextBox.Text = builder.Result.SQL;
            QueryTextFormats formats = new QueryTextFormats();
            formats.UseHtml = true;
            formats.UseMathSymbolsForOperators = true;

            ResultGrid.Visible = false;

        }
        catch {
            SqlTextBox.Text = "";
       }
    }

    protected void UpdateResultBtn_Click(object sender, EventArgs e) {
        if (SqlTextBox.Text.StartsWith("SELECT", StringComparison.InvariantCultureIgnoreCase)) { //we do not allow to execute statements other that SELECT
            try {
                ResultDS.SelectCommand = SqlTextBox.Text;
                ResultDS.Select(DataSourceSelectArguments.Empty);
                ResultLabel.Visible = false;
                ResultGrid.Visible = true;
            }
            catch (Exception ex) {
                ResultGrid.Visible = false;
                ResultLabel.Width = new Unit("100%");
                ResultLabel.Text = "Error in SQL statement: " + ex.Message;
                ResultLabel.Visible = true;

            }
        }
    }

    protected void QueryPanel1_CreateValueElement(object sender, Korzh.EasyQuery.WebControls.CreateValueElementEventArgs e) {
        // this method demonstrates an ability to change value elelements at run-time
        // for example in this case we change element from ListRowElement to EditRowElement if list of available values is too long

        if (e.ConditionRow.Condition is SimpleCondition) {
            Expression baseExpr = ((SimpleCondition)e.ConditionRow.Condition).BaseExpr;
            EntityAttr attr = ((DbEntityAttrExpr)baseExpr).Attribute;
            if (attr.DefaultEditor is SqlListValueEditor) {
                string sql = ((SqlListValueEditor)attr.DefaultEditor).SQL;
                if (ResultSetIsTooBig(sql)) { //or put your condition here
                    e.Element = new Korzh.EasyQuery.WebControls.EditXElement();
                }
            }
        }
    }

    private bool ResultSetIsTooBig(string sql) {
        CheckConnection();
        OleDbDataAdapter resultDA = new OleDbDataAdapter(sql, DbConnection);

        DataSet tempDS = new DataSet();
        resultDA.Fill(tempDS, "Result");
        return tempDS.Tables[0].Rows.Count > 100;
    }

    protected void Button1_Click(object sender, EventArgs e) {
        string path = AppDomain.CurrentDomain.BaseDirectory;
        path += "data\\nwind2.xml";
        query.Model.LoadFromFile(path);
        QueryPanel1.UpdateModelInfo();

        QueryColumnsPanel1.UpdateModelInfo();
    }

    protected void ExportExcelBtn_Click(object sender, EventArgs e) {
        //ExportResultToCSV("result.csv");
        ExportResultToExcel("result.xls");
    }

    protected void ExportResultToCSV(string fileName) {
        ResultDS.SelectCommand = SqlTextBox.Text;
        DataView view = (DataView)ResultDS.Select(DataSourceSelectArguments.Empty);
        if (view == null) return;
        StringBuilder result = new StringBuilder("");
        foreach (DataRowView row in view) {
            int i = 0;
            foreach (DataColumn col in view.Table.Columns) {
                object obj = row[i];
                string s = obj == null ? string.Empty : obj.ToString();
                if (i > 0) result.Append(',');
                result.Append("\"" + ConvertToCSV(s) + "\"");
                i++;
            }
            result.Append(Environment.NewLine);
        }

        Response.ClearHeaders();
        Response.Clear();
        Response.ContentType = "text/csv";
        Response.BufferOutput = true;
        Response.AddHeader("Content-Disposition", "attachment;filename=" + fileName);

        byte[] output = System.Text.UnicodeEncoding.UTF8.GetBytes(result.ToString());

        Response.OutputStream.Write(output, 0, output.GetLength(0));

        Response.End();
    }

    protected string ConvertToCSV(string s) {
        string result = s.Replace(",", "\\,");
        result = result.Replace("\"", "\\\"");
        return result;
    }


    protected void ExportResultToExcel(string fileName) {
        Response.Clear();
        Response.Buffer = true;
        Response.ContentType = "application/vnd.ms-excel";
        Response.AddHeader("content-disposition", "attachment;filename=" + fileName);
        Response.Charset = "";
        this.EnableViewState = false;

        System.IO.StringWriter sw = new System.IO.StringWriter();
        System.Web.UI.HtmlTextWriter htw = new System.Web.UI.HtmlTextWriter(sw);

        ResultGrid.RenderControl(htw);

        Response.Write(sw.ToString());
        Response.End();
    }

    public override void VerifyRenderingInServerForm(Control control) {
		//it is necessary for "Export to Excel" operation
        //we just ignore this event for GridView and do in usual way for all other controls
        if (control != ResultGrid)
            base.VerifyRenderingInServerForm(control);
    }

    protected void LangSwitch_Command(object sender, CommandEventArgs e) {
        Session[langSessionName] = e.CommandArgument;
        Response.Redirect(Request.Path, true);
    }
}
