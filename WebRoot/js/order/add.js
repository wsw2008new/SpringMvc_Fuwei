$(document).ready( function() {
	/* 设置当前选中的页 */
	var $a = $("#left li a[href='order/add']");
	setActiveLeft($a.parent("li"));
	/* 设置当前选中的页 */

	// 重置按钮
		$("button.reset").click( function() {
			$form = $(this).closest("form");
			$form[0].reset();
			$("#previewWidget img").attr("src", "");
		});
		// 重置按钮
		
		
		
		//2015-2-27添加颜色及数量
		//订单明细
		var orderGrid = new OrderGrid({
			$content:$("#orderDetail"),
			tbOptions:{
				$dialog:$("#orderDetailDialog"),
				colnames : [
						{
							name :'color',
							colname :'颜色',
							width :'10%'
						},
						{
							name :'weight',
							colname :'克重(g)',
							width :'10%'
						},
						{
							name :'produce_weight',
							colname :'机织克重(g)',
							width :'10%'
						},
						{
							name :'yarn_name',
							colname :'纱线种类',
							width :'10%'
						},
						{
							name :'size',
							colname :'尺寸',
							width :'10%'
						},
						{
							name :'quantity',
							colname :'生产数量',
							width :'10%'
						},
						{
							name :'price',
							colname :'单价',
							width :'10%'
						},
						{
							name :'_handle',
							colname :'操作',
							width :'10%',
							displayValue : function(value, rowdata) {
								return "<a class='copyRow' href='#'>复制</a> | <a class='editRow' href='#'>修改</a> | <a class='deleteRow' href='#'>删除</a>";
							}
						} ],
						changeTotalRow : function() {
							var TableInstance = this;
							// 2015-2-28添加
							var tabledata = TableInstance.getTableData();
							var total_quantity = 0;
							var total_amount = 0 ;
							for ( var i in tabledata) {
								total_quantity += tabledata[i].quantity;
								total_amount += Number(tabledata[i].quantity * tabledata[i].price);
							}
							$(".orderform #quantity").val(total_quantity);
							$(".orderform #amount").val(total_amount);
							// 2015-2-28添加
						}
			}
		});
		//2015-2-27添加颜色及数量
		
		var $form = $(".orderform");
		var $submitBtn = $form.find("[type='submit']");
		$form.unbind("submit");
		$form.submit( function() {
			var sampleId = $(this).find("#sampleId").val();
			if (sampleId == "") {
				Common.Error("添加失败：" + "请必须选择样品");
			}
			if (!Common.checkform(this)) {
				return false;
			}
			var formdata = $(this).serializeJson();
			//2015-2-27添加颜色及数量
			var detailTbdata = orderGrid.TableInstance.getTableData();
			formdata.details = JSON.stringify(detailTbdata);
			//2015-2-27添加颜色及数量
			// 获取表格数据
				$submitBtn.button('loading');
				$.ajax( {
					url :"order/add",
					type :'POST',
					data :$.param(formdata),
					success : function(result) {
						if (result.success) {
							Common.Tip("添加成功", function() {
								location = "order/detail/" + result.id;
							});
						}
						$submitBtn.button('reset');
					},
					error : function(result) {
						Common.Error("添加失败：" + result.responseText);
						$submitBtn.button('reset');
					}

				});
				return false;
			});

		// 公司-业务员级联
		$("#companyId").change( function() {
			changeCompany(this.value);
		});
		// 公司-业务员级联

	    
		// 2014-11-10添加选择样品
		$("#sampleImgA").click( function() {
			$("#chooseSampleBtn").click();
			return false;
		});
		$("#chooseSampleBtn").click( function() {
			// 出现样品选择弹出框
				var src = $("#sampleIframe").attr("src");
				if (!src || src == "") {
					$("#sampleIframe").attr("src", "sample/search");
				}
				$("#sampleDialog").modal();

				// 设置样品弹出框表格选中之后的操作
				window.searchback = function(sampleId) {
					// 将数据填充到页面上
					$.ajax( {
						url :"sample/get/" + sampleId,
						type :'GET',
						success : function(sample) {
							sample.sampleId = sample.id;
							if(sample.charge_employee == null){
								sample.charge_employee = "";
							}
							sample.company_productNumber = sample.productNumber;
							Common.fillForm($(".orderform #sampleInfoWidget")[0], sample);
							$("#sampleImgA").attr("href", "/" + sample.img);
							$("#sampleImg").attr("src", "/" + sample.img_s);
							$("#sampleDialog").modal('hide');
							$("#company_productNumber").focus();
							$("#company_productNumber").select();
						},
						error : function(result) {
							Common.Error("获取订单详情信息失败：" + result.responseText);
							$("#sampleDialog").modal('hide');
						}
					});
				};
			});

		// 2014-11-10添加选择样品
		
		
	});
function totalAmount() {
	var amount = 0;
	var $trs = $("#detailTable tbody tr");
	for ( var i = 0; i < $trs.length; ++i) {
		var $tr = $trs.eq(i);
		amount += Number($tr.find(".amount").text());
	}
	return amount.toFixed(2);
}
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

//2015-2-27添加颜色及数量
function OrderGrid(settings){
	var Object = this;
	this.$content = settings.$content || null;
	this.tbOptions = settings.tbOptions || null;
	if(this.tbOptions){
		this.tbOptions.tableEle = $(this.$content).find(".detailTb")[0];
		if(!this.tbOptions.showNoOptions){
			this.tbOptions.showNoOptions = {
					width :'5%',
					display :false
				};
		}
	}
	
	this.$dialog = settings.tbOptions.$dialog || null;
	this.$form = null;
	if(this.$dialog){
		this.$form = this.$dialog.find(".rowform");
	}
	
	this.init = function(){
		Object.TableInstance = TableTools.createTableInstance(Object.tbOptions);
		if(Object.$dialog){
			Object.$dialog.on('shown.bs.modal', function () {
				Object.$dialog.find("input[type='text'],select").first().focus();
			});
		}
		this.$content.find(".detailTb .addRow").click( function() {
			Common.resetForm(Object.$form[0]);
			Object.$dialog.find(".modal-title").text("添加一行");
			//2016-3-7添加功能：复制样品的尺寸、材料、克重到默认的数据中
			var formdata={};
			formdata.weight = $("#sampleInfoWidget #weight").val();
			formdata.size = $("#sampleInfoWidget #size").val();
			formdata.yarn = $("#sampleInfoWidget #materialId").val();
			Common.fillForm(Object.$form[0],formdata);
			//2016-3-7添加功能：复制样品的尺寸、材料、克重到默认的数据中
			
			Object.$dialog.modal();

			Object.$form.unbind("submit");
			Object.$form.bind("submit", function() {
				// 添加一行
					if (!Common.checkform(this)) {
						return false;
					}
					var formdata = $(this).serializeJson();
					var $material = $(this).find("select#material");
					if($material.length > 0){
						formdata.material_name = $material.find("option:selected").text();
					}
					var $yarn = $(this).find("select#yarn");
					if($yarn.length > 0){
						formdata.yarn_name = $yarn.find("option:selected").text();
					}
					var $factoryId = $(this).find("select#factoryId");
					if($factoryId.length > 0){
						formdata.factory_name = $factoryId.find("option:selected").text();
					}
					var $styleId = $(this).find("select#style");
					if($styleId.length > 0){
						formdata.style_name = $styleId.find("option:selected").text();
					}
					
					Object.TableInstance.addRow(formdata);
					Object.$dialog.modal("hide");
					return false;
				});
		});
		this.$content.find(".detailTb").on("click", ".editRow", function() {
			Common.resetForm(Object.$form[0]);
			Object.$dialog.find(".modal-title").text("编辑");
			var $tr = $(this).closest("tr");
			var rowdata = $.parseJSON($tr.attr("data"));
			Common.fillForm(Object.$form[0],rowdata);
			Object.$dialog.modal();
			Object.$form.unbind("submit");
			Object.$form.bind("submit", function() {
				if (!Common.checkform(this)) {
					return false;
				}
				// 修改一行
				var formdata = $(this).serializeJson();
				var $material = $(this).find("select#material");
				if($material.length > 0){
					formdata.material_name = $material.find("option:selected").text();
				}
				var $yarn = $(this).find("select#yarn");
				if($yarn.length > 0){
					formdata.yarn_name = $yarn.find("option:selected").text();
				}
				var $factoryId = $(this).find("select#factoryId");
				if($factoryId.length > 0){
					formdata.factory_name = $factoryId.find("option:selected").text();
				}
				var $styleId = $(this).find("select#style");
				if($styleId.length > 0){
					formdata.style_name = $styleId.find("option:selected").text();
				}
				
				Object.TableInstance.updateRow(formdata,$tr[0]);
				Object.$dialog.modal("hide");
				return false;
			});
			return false;
		});
		
		//2015-4-16添加复制一行
		this.$content.find(".detailTb").on("click", ".copyRow", function() {
			Common.resetForm(Object.$form[0]);
			Object.$dialog.find(".modal-title").text("添加一行");

			var $tr = $(this).closest("tr");
			var rowdata = $.parseJSON($tr.attr("data"));
			delete rowdata.id;
			delete rowdata.color;
			delete rowdata.quantity;

			
			Common.fillForm(Object.$form[0],rowdata);
			Object.$dialog.modal();
			Object.$form.unbind("submit");
			Object.$form.bind("submit", function() {
				// 添加一行
					if (!Common.checkform(this)) {
						return false;
					}
					var formdata = $(this).serializeJson();
					var $material = $(this).find("select#material");
					if($material.length > 0){
						formdata.material_name = $material.find("option:selected").text();
					}
					var $yarn = $(this).find("select#yarn");
					if($yarn.length > 0){
						formdata.yarn_name = $yarn.find("option:selected").text();
					}
					var $factoryId = $(this).find("select#factoryId");
					if($factoryId.length > 0){
						formdata.factory_name = $factoryId.find("option:selected").text();
					}
					var $styleId = $(this).find("select#style");
					if($styleId.length > 0){
						formdata.style_name = $styleId.find("option:selected").text();
					}
					
					Object.TableInstance.addRow(formdata);
					Object.$dialog.modal("hide");
					return false;
				});
			return false;
		});

		this.$content.find(".detailTb").on("click", ".deleteRow", function() {
			Object.TableInstance.deleteRow($(this).closest("tr")[0]);
			return false;
		});
	};
	
	this.init();
}
//2015-2-27添加颜色及数量