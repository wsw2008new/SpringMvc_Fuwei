package com.fuwei.entity.producesystem;

import java.util.List;

import net.keepsoft.commons.annotation.IdentityId;
import net.keepsoft.commons.annotation.Table;
import net.keepsoft.commons.annotation.Temporary;

import com.fuwei.util.SerializeTool;

@Table("tb_half_current_stock")
public class HalfCurrentStock {
	@IdentityId
	private int id;
	private int orderId;	
	private int total_stock_quantity;
	
	private String detail_json;
	@Temporary
	private List<HalfCurrentStockDetail> detaillist ;

	
	// 接下来是Order的属性
	@Temporary
	private Integer companyId;// 公司ID
	@Temporary
	private Integer sampleId;// 样品ID
	@Temporary
	private String name;// 样品名称
	@Temporary
	private String img;// 图片
	@Temporary
	private String orderNumber;//订单编号
	@Temporary
	private String img_s;// 中等缩略图
	@Temporary
	private String img_ss;// 缩略图
	@Temporary
	private Integer charge_employee;// 打样人 
	@Temporary
	private String company_productNumber;//样品的公司货号
	
	
	

	public Integer getCompanyId() {
		return companyId;
	}
	public void setCompanyId(Integer companyId) {
		this.companyId = companyId;
	}
	public Integer getSampleId() {
		return sampleId;
	}
	public void setSampleId(Integer sampleId) {
		this.sampleId = sampleId;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getImg() {
		return img;
	}
	public void setImg(String img) {
		this.img = img;
	}
	public String getOrderNumber() {
		return orderNumber;
	}
	public void setOrderNumber(String orderNumber) {
		this.orderNumber = orderNumber;
	}
	public String getImg_s() {
		return img_s;
	}
	public void setImg_s(String img_s) {
		this.img_s = img_s;
	}
	public String getImg_ss() {
		return img_ss;
	}
	public void setImg_ss(String img_ss) {
		this.img_ss = img_ss;
	}
	public Integer getCharge_employee() {
		return charge_employee;
	}
	public void setCharge_employee(Integer charge_employee) {
		this.charge_employee = charge_employee;
	}
	public String getCompany_productNumber() {
		return company_productNumber;
	}
	public void setCompany_productNumber(String company_productNumber) {
		this.company_productNumber = company_productNumber;
	}
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}


	public int getOrderId() {
		return orderId;
	}


	public void setOrderId(int orderId) {
		this.orderId = orderId;
	}

	public int getTotal_stock_quantity() {
		return total_stock_quantity;
	}


	public void setTotal_stock_quantity(int total_stock_quantity) {
		this.total_stock_quantity = total_stock_quantity;
	}

	public String getDetail_json() {
		return detail_json;
	}


	public void setDetail_json(String detail_json) throws Exception {
		if(detail_json != null && !detail_json.equals("")){
			this.setDetaillist(SerializeTool.deserializeList(detail_json,HalfCurrentStockDetail.class));
		}
		this.detail_json = detail_json;
	}
	
	public List<HalfCurrentStockDetail> getDetaillist() {
		return detaillist;
	}
	public void setDetaillist(List<HalfCurrentStockDetail> detaillist) {
		this.detaillist = detaillist;
	}
	
}
