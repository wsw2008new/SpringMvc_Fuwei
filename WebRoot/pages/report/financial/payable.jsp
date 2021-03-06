<%@ page language="java" import="java.util.*" pageEncoding="utf-8"
	contentType="text/html; charset=utf-8"%>
<%@page import="com.fuwei.entity.User"%>
<%@page import="com.fuwei.entity.Company"%>
<%@page import="com.fuwei.entity.financial.Bank"%>
<%@page import="com.fuwei.entity.financial.Subject"%>
<%@page import="com.fuwei.commons.Pager"%>
<%@page import="com.fuwei.util.DateTool"%>
<%@page import="com.fuwei.commons.SystemCache"%>
<%@page import="com.fuwei.util.NumberUtil"%>
<%@page import="com.fuwei.entity.report.Payable"%>
<%@page import="com.fuwei.entity.Salesman"%>
<%@page import="net.sf.json.JSONObject"%>
<%
	String path = request.getContextPath();
	String basePath = request.getScheme() + "://"
			+ request.getServerName() + ":" + request.getServerPort()
			+ path + "/";
	Pager pager = (Pager) request.getAttribute("pager");
	if (pager == null) {
		pager = new Pager();
	}
	List<Payable> payablelist = new ArrayList<Payable>();
	double total_payable = 0 ;
	double total_pay = 0 ;
	double total_unpay = 0;
	double total_uninvoiced = 0;
	double total_pay_personal = 0;
	if (pager != null & pager.getResult() != null) {
		payablelist = (List<Payable>) pager.getResult();
		total_payable = NumberUtil.formateDouble((Double)pager.getTotal().get("payable"),2);
		total_pay = NumberUtil.formateDouble((Double)pager.getTotal().get("pay"),2);
		total_unpay = NumberUtil.formateDouble((Double)pager.getTotal().get("un_pay"),2);
		total_uninvoiced = NumberUtil.formateDouble((Double)pager.getTotal().get("un_invoiced"),2);
		total_pay_personal = NumberUtil.formateDouble((Double)pager.getTotal().get("pay_personal"),2);
	}

	Date start_time = (Date) request.getAttribute("start_time");
	String start_time_str = "";
	if (start_time != null) {
		start_time_str = DateTool.formatDateYMD(start_time);
	}
	Date end_time = (Date) request.getAttribute("end_time");
	String end_time_str = "";
	if (end_time != null) {
		end_time_str = DateTool.formatDateYMD(end_time);
	}


	Integer bank_id = (Integer) request.getAttribute("bank_id");
	String bank_str = "";
	if (bank_id != null) {
		bank_str = String.valueOf(bank_id);
	}
	if (bank_id == null) {
		bank_id = -1;
	}
	
	Integer salesmanId = (Integer) request.getAttribute("salesmanId");
	Integer companyId = (Integer) request.getAttribute("companyId");
	String company_str = "";
	String salesman_str = "";
	if (salesmanId != null) {
		salesman_str = String.valueOf(salesmanId);
	}
	if (companyId != null) {
		company_str = String.valueOf(companyId);
	}
	if (salesmanId == null) {
		salesmanId = -1;
	}
	if (companyId == null) {
		companyId = -1;
	}
	
	
	Integer subject_id = (Integer) request.getAttribute("subject_id");
	String subject_str = "";
	if (subject_id != null) {
		subject_str = String.valueOf(subject_id);
	}
	if (subject_id == null) {
		subject_id = -1;
	}
	
	List<Subject> subjectlist = (List<Subject>) request
			.getAttribute("subjectlist");
	List<Bank> banklist = (List<Bank>) request.getAttribute("banklist");

	HashMap<String, List<Salesman>> companySalesmanMap = SystemCache
			.getCompanySalesmanMap_ID();
	JSONObject jObject = new JSONObject();
	jObject.put("companySalesmanMap", companySalesmanMap);
	String companySalesmanMap_str = jObject.toString();
	
%>
<!DOCTYPE html>

<html>
	<head>
		<base href="<%=basePath%>">
		<title>应付报表 -- 财务报表 -- 桐庐富伟针织厂</title>
		<meta charset="utf-8">
		<meta http-equiv="keywords" content="针织厂,针织,富伟,桐庐">
		<meta http-equiv="description" content="富伟桐庐针织厂">
		<meta http-equiv="X-UA-Compatible" content="IE=edge">
		<!-- 为了让IE浏览器运行最新的渲染模式 -->
		<link href="css/plugins/bootstrap.min.css" rel="stylesheet"
			type="text/css" />
		<link href="css/plugins/font-awesome.min.css" rel="stylesheet"
			type="text/css" />
		<link href="css/common/common.css" rel="stylesheet" type="text/css" />
		<script src="js/plugins/jquery-1.10.2.min.js"></script>
		<script src="js/plugins/bootstrap.min.js" type="text/javascript"></script>
		<script src="<%=basePath%>js/plugins/WdatePicker.js"></script>
		<script src="js/common/common.js" type="text/javascript"></script>
		<script type='text/javascript' src='js/plugins/select2.min.js'></script>
		<link rel="stylesheet" type="text/css"
			href="css/plugins/select2.min.css" />
		<link href="css/report/financial.css" rel="stylesheet" type="text/css" />
	</head>
	<body>
		<%@ include file="../../common/head.jsp"%>
		<div id="Content">
			<div id="main">
				<div class="breadcrumbs" id="breadcrumbs">
					<ul class="breadcrumb">
						<li>
							<i class="fa fa-home"></i>
							<a href="user/index">首页</a>
						</li>
						<li>
							财务报表
						</li>
						<li class="active">
							应付报表
						</li>
					</ul>
				</div>
				<div class="body">
					<div class="container-fluid">
						<div class="row">
							<div class="col-md-12 tablewidget">
								<!-- Table -->
								<div clas="navbar navbar-default">
									<form class="form-horizontal searchform form-inline searchform"
										role="form">
										<input type="hidden" name="page" value="1">
										<div class="form-group salesgroup">
											<label for="companyId" class="col-sm-3 control-label">
												公司
											</label>
											<div class="col-sm-9">
												<select data='<%=companySalesmanMap_str%>'
													class="form-control" name="companyId" id="companyId"
													placeholder="公司">
													<option value="">
														所有
													</option>
													<%
														for (Company company : SystemCache.companylist) {
															if (companyId != null && companyId == company.getId()) {
													%>
													<option value="<%=company.getId()%>" selected><%=company.getShortname()%></option>
													<%
														} else {
													%>
													<option value="<%=company.getId()%>"><%=company.getShortname()%></option>
													<%
														}
														}
													%>
												</select>
											</div>
										</div>
										<div class="form-group salesgroup">
											<label for="salesmanId" class="col-sm-4 control-label">
												业务员
											</label>
											<div class="col-sm-8">
												<select class="form-control" name="salesmanId"
													id="salesmanId" placeholder="业务员">
													<option value="">
														所有
													</option>
													<%
														for (Salesman salesman : SystemCache.getSalesmanList(companyId)) {
															if (salesmanId != null && salesmanId == salesman.getId()) {
													%>
													<option value="<%=salesman.getId()%>" selected><%=salesman.getName()%></option>
													<%
														} else {
													%>
													<option value="<%=salesman.getId()%>"><%=salesman.getName()%></option>
													<%
														}
														}
													%>
												</select>
											</div>
										</div>
										<div class="form-group salesgroup">
											<label for="subject_id" class="col-sm-3 control-label">
												科目
											</label>
											<div class="col-sm-8">
												<select class="form-control require" name="subject_id"
													id="subject_id">
													<option value="">
														未选择
													</option>
													<%
														for (Subject subject : subjectlist) {
															if (subject_id != null && subject_id == subject.getId()) {
													%>
													<option value="<%=subject.getId()%>" selected><%=subject.getName()%></option>
													<%
														} else {
													%>
													<option value="<%=subject.getId()%>"><%=subject.getName()%></option>
													<%
														}
														}
													%>


												</select>
											</div>
										</div>
										<div class="form-group salesgroup">
											<label for="bank_id" class="col-sm-3 control-label">
												对方账户
											</label>
											<div class="col-sm-8">
												<select class="form-control" name="bank_id" id="bank_id">
													<option value="">
														未选择
													</option>
													<%
																	for (Bank bank : banklist) {
																		if (bank_id != null && bank_id == bank.getId()) {
																%>
													<option value="<%=bank.getId()%>" selected><%=bank.getName()%></option>
													<%
																	} else {
																%>
													<option value="<%=bank.getId()%>"><%=bank.getName()%></option>
													<%
																	}
																	}
																%>
												</select>
											</div>
										</div>

										<div class="form-group timegroup">
											<label class="col-sm-3 control-label">
												记录日期
											</label>

											<div class="input-group col-md-9">
												<input type="text" name="start_time" id="start_time"
													class="date form-control" value="<%=start_time_str%>" />
												<span class="input-group-addon">到</span>
												<input type="text" name="end_time" id="end_time"
													class="date form-control" value="<%=end_time_str%>">
											</div>

										</div>
										<br>
										<button class="btn btn-primary" type="submit" id="searchBtn">
											搜索
										</button><a class="exportBtn btn btn-primary" type="button" href="report/financial/payable/export?companyId=<%=company_str %>&salesmanId=<%=salesman_str%>&subject_id=<%=subject_str %>&bank_id=<%=bank_str%>&start_time=<%=start_time_str%>&end_time=<%=end_time_str%>">
											导出
										</a>
										<ul class="pagination">
											<li>
												<a
													href="report/financial/payable?companyId=<%=company_str %>&salesmanId=<%=salesman_str%>&subject_id=<%=subject_str %>&bank_id=<%=bank_str%>&start_time=<%=start_time_str%>&end_time=<%=end_time_str%>&page=1">«</a>
											</li>

											<%
														if (pager.getPageNo() > 1) {
													%>
											<li class="">
												<a
													href="report/financial/payable?companyId=<%=company_str %>&salesmanId=<%=salesman_str%>&subject_id=<%=subject_str %>&bank_id=<%=bank_str%>&start_time=<%=start_time_str%>&end_time=<%=end_time_str%>&page=<%=pager.getPageNo() - 1%>">上一页
													<span class="sr-only"></span> </a>
											</li>
											<%
														} else {
													%>
											<li class="disabled">
												<a disabled>上一页 <span class="sr-only"></span> </a>
											</li>
											<%
														}
													%>

											<li class="active">
												<a
													href="report/financial/payable?companyId=<%=company_str %>&salesmanId=<%=salesman_str%>&subject_id=<%=subject_str %>&bank_id=<%=bank_str%>&start_time=<%=start_time_str%>&end_time=<%=end_time_str%>&page=<%=pager.getPageNo()%>"><%=pager.getPageNo()%>/<%=pager.getTotalPage()%>，共<%=pager.getTotalCount()%>条<span
													class="sr-only"></span> </a>
											</li>
											<li>
												<%
															if (pager.getPageNo() < pager.getTotalPage()) {
														%>
											
											<li class="">
												<a
													href="report/financial/payable?companyId=<%=company_str %>&salesmanId=<%=salesman_str%>&subject_id=<%=subject_str %>&bank_id=<%=bank_str%>&start_time=<%=start_time_str%>&end_time=<%=end_time_str%>&page=<%=pager.getPageNo() + 1%>">下一页
													<span class="sr-only"></span> </a>
											</li>
											<%
														} else {
													%>
											<li class="disabled">
												<a disabled>下一页 <span class="sr-only"></span> </a>
											</li>
											<%
														}
													%>

											</li>
											<li>
												<a
													href="report/financial/payable?companyId=<%=company_str %>&salesmanId=<%=salesman_str%>&subject_id=<%=subject_str %>&bank_id=<%=bank_str%>&start_time=<%=start_time_str%>&end_time=<%=end_time_str%>&page=<%=pager.getTotalPage()%>">»</a>
											</li>
										</ul>
									</form>


								</div>

								<table class="table table-responsive table-bordered">
									<thead>
										<tr>
											<th width="20px">
												No.
											</th>
											<th width="80px">
												类型
											</th>
											<th width="120px">
												对方账户
											</th>
											<th width="60px">
												应付
											</th>
											<th width="60px">
												已付
											</th>
											<!-- <th width="60px">
															未付
														</th> -->
											<th width="60px">
												未匹配
											</th>
											<th width="60px">
												付款/收票日期
											</th>
											<th width="100px">
												备注
											</th>
										</tr>
									</thead>
									<tbody>

										<%
														int i = (pager.getPageNo() - 1) * pager.getPageSize() + 0;
														for (Payable item : payablelist) {
													%>
										<tr>
											<td><%=++i%></td>
											<%if(item.getType().equals("invoice")){ %>
											<td>
												<a target="_blank" class="detailA"
													href="purchase_invoice/detail/<%=item.getType_id() %>"><%=item.getTypeString()%>[id:<%=item.getType_id() %>]</a>
											</td>
											<td><%=item.getBank_name()%></td>
											<td><%=item.getPayable()%></td>
											<td></td>

											<td></td>
											<%}else{ %>
											<td>
												<a target="_blank" class="detailA"
													href="expense/detail/<%=item.getType_id() %>"><%=item.getTypeString()%>[id:<%=item.getType_id() %>]</a>
											</td>
											<td><%=item.getBank_name()%></td>
											<td></td>
											<td><%=item.getPay()%></td>

											<td><%=item.getUn_invoiced()%></td>
											<%} %>

											<td><%=DateTool.formatDateYMD(item.getRecord_at())%></td>
											<td><%=item.getMemo()%></td>

										</tr>
										<%
														}
													%>
										<%if(payablelist == null || payablelist.size() <= 0){ %>
										<tr>
											<td colspan="8">
												找不到符合条件的记录
											</td>
										</tr>
										<%}else{ %>
									</tbody>
									<tfoot>
										<tr>
											<td></td>
											<td>
												合计
											</td>
											<td></td>
											<td><%=String.format("%.2f",total_payable) %></td>
											<td><%=String.format("%.2f",total_pay)%></td>
											<td><%=String.format("%.2f",total_uninvoiced)%></td>
											<td></td>
											<td></td>
										</tr>
										<tr>
											<td></td>
											<td></td>
											<td></td>
											<td>
												实际未付：
											</td>
											<td colspan="4" style="text-align: left; padding-left: 10px;"><%=NumberUtil.formateDouble(total_payable-total_pay,2)%>
												(应付-已付) +
												<%=total_pay_personal %>
												(支付给个人的无需收发票) =
												<%= NumberUtil.formateDouble(total_payable-total_pay + total_pay_personal,2)%></td>
										</tr>
									</tfoot>
									<%} %>
								</table>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<script type="text/javascript">
	/*设置当前选中的页*/
	var $a = $("#left li a[href='report/financial/payable']");
	setActiveLeft($a.parent("li"));
	$("#bank_id").select2();

	// 公司-业务员级联
	$("#companyId").change( function() {
		changeCompany(this.value);
	});
	// 公司-业务员级联
	function changeCompany(companyId) {
		var companyName = $("#companyId").val();
		var companySalesmanMap = $("#companyId").attr("data");
		companySalesmanMap = $.parseJSON(companySalesmanMap).companySalesmanMap;
		var SalesNameList = companySalesmanMap[companyName];
		$("#salesmanId").empty();
		var frag = document.createDocumentFragment();
		var option = document.createElement("option");
		option.value = "";
		option.text = "未选择";
		frag.appendChild(option);
		if (SalesNameList) {
			for ( var i = 0; i < SalesNameList.length; ++i) {
				var salesName = SalesNameList[i];
				var option = document.createElement("option");
				option.value = salesName.id;
				option.text = salesName.name;
				frag.appendChild(option);
			}
		}

		$("#salesmanId").append(frag);
	}
</script>
	</body>
</html>


