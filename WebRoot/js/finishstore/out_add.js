$(document).ready( function() {
	/* 设置当前选中的页 */
	/*设置当前选中的页*/
	var $a = $("#left li a[href='finishstore_workspace/workspace']");
	setActiveLeft($a.parent("li"));
	/* 设置当前选中的页 */
	$(".quantity,.cartons").bind("blur",function(){
		if(this.value == ""){
			this.value = 0 ;
		}
	});
	$(".quantity,.cartons").click(function(){
		$(this).focus();
		$(this).select();
	});
	
	
	//2015-4-3 添加自动focus到第一个可输入input、select
	$("form").find(".quantity").not("[readonly],[disabled]").first().click();
	//2015-4-3 添加自动focus到第一个可输入input、select
		var storInGrid = new OrderGrid({
			tipText:"成品发货单",
			url:"finishstore_out/add",
			postUrl:"finishstore_out/put",
			$content:$(".body"),
			donecall:function(result){
				Common.Tip("请打印成品发货单", function() {
					location.href = "finishstore_out/detail/" + result.id;
				});
			},
			tbOptions:{
				tableEle : $(".detailTb")[0],
				showNoOptions : {
					width :'5%',
					display :false
				},
				colnames : [
						{
							name :'quantity',
							colname :'数量',
							width :'30%'
						},{
							name :'cartons',
							colname :'箱数',
							width :'30%'
						}]
			}
			
		});
		
		//设置箱数的自动计算 , 箱数 = 数量/每箱数量
		$(storInGrid.TableInstance.tableEle).on("input propertychange","input.quantity",function(event) {
			$tr = $(this).closest("tr");
			var $quantity = $tr.find("input.quantity");
			var data = $.parseJSON($tr.attr("data"));
			var $cartons = $tr.find(".cartons");
			
			var quantity = Number($quantity.val());
			var per_carton_quantity =data.per_carton_quantity;
			
			var cartons = 0;
			if(per_carton_quantity != 0){
				cartons = Math.ceil(quantity/per_carton_quantity);
			}
			$cartons.val(cartons);
		});
		//设置数量的自动计算 , 数量 = 箱数*每箱数量
		$(storInGrid.TableInstance.tableEle).on("input propertychange","input.cartons",function(event) {
			$tr = $(this).closest("tr");
			var $quantity = $tr.find(".quantity");
			var data = $.parseJSON($tr.attr("data"));
			var $cartons = $tr.find(".cartons");
			
			//var quantity = Number($quantity.val());
			var cartons = Number($cartons.val());
			var per_carton_quantity =data.per_carton_quantity;
			
			var quantity = cartons * per_carton_quantity;
			$quantity.val(quantity);
		});
		
	});
	