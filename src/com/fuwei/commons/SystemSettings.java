package com.fuwei.commons;

import java.util.Date;

import com.fuwei.service.SystemSettingService;


public class SystemSettings {
	public static String sample_display_start_at = null;//样品展示起始时间
	public static String sample_display_end_at = null;//样品展示结束时间
	public static Double local_tax_rate = null;//地税税率
	public static Boolean yanchang = null;//当前是否是验厂状态
	static SystemSettingService systemSettingService;
	public static void init() throws Exception {
		if(systemSettingService == null){
			systemSettingService = (SystemSettingService) SystemContextUtils
					.getBean(SystemSettingService.class);
		}
		systemSettingService.initSettings();
	}
	public static String yanchangString(){
		if(yanchang){
			return "验厂中";
		}else{
			return "不在验厂";
		}
	}
}
