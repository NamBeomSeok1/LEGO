package modoo.front.cmm.web;


import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import modoo.module.common.service.JsonResult;
import modoo.module.shop.goods.info.service.GoodsCouponService;
import modoo.module.shop.goods.info.service.GoodsCouponVO;
import net.minidev.json.parser.JSONParser;
import net.sf.json.JSONArray;
import net.sf.json.JSONObject;
import net.sf.json.JSONSerializer;
import org.apache.commons.lang3.StringUtils;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import javax.annotation.Resource;
import javax.json.JsonArray;
import javax.json.JsonValue;
import javax.servlet.http.HttpServletResponse;
import java.io.PrintWriter;
import java.net.URI;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;


@Controller
public class ApiController{

	@Resource(name = "goodsCouponService")
	private GoodsCouponService goodsCouponService;

//도로명 API폼 
	@RequestMapping(value="/api/zipSearch.do", method=RequestMethod.GET)
	public String zipSearchMove(){
	
		return "modoo/front/shop/order/address";
	}

	/**
	 * 수강권 쿠폰 유효성 체크
	 * @param data
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/api/couponValid.json",method = {RequestMethod.GET,RequestMethod.POST})
	public void validVoucherCoupon(@RequestBody HashMap<String,String> data,HttpServletResponse response) throws Exception {
		String successYn = "Y";
		String message = "";

		String couponNo = String.valueOf(data.get("couponNo"));
		GoodsCouponVO goodsCouponVO = new GoodsCouponVO();
		goodsCouponVO.setCouponNo(couponNo);

		List<GoodsCouponVO> list = goodsCouponService.selectGoodsCouponList(goodsCouponVO);
		if(list.size()<1){
			message="유효하지 않은 쿠폰번호입니다.";
			successYn="N";
		}else{
			goodsCouponVO = goodsCouponService.selectGoodsCoupon(goodsCouponVO);
			successYn = (StringUtils.equals(goodsCouponVO.getCouponSttusCode(),"USE")||StringUtils.equals(goodsCouponVO.getCouponSttusCode(),"CANCL"))?"N":"Y";
		}

		JSONObject jObj = new JSONObject();
		response.setContentType("application/json;charset=utf-8");

		jObj.put("successYn",successYn);
		jObj.put("message",message);

		PrintWriter printWriter = response.getWriter();
		printWriter.println(jObj.toString());
		printWriter.flush();
		printWriter.close();

	}

	/**
	 * 폭스포털 지녀 리스트 api
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value="/api/selectChildList.json",method = {RequestMethod.GET,RequestMethod.POST})
	@ResponseBody
	public JsonResult selectChildList(HttpServletResponse response) throws Exception {

		LoginVO user = (LoginVO) EgovUserDetailsHelper.getAuthenticatedUser();
		JsonResult result = new JsonResult();
		String message = "";

		HttpPost httpPost = new HttpPost();
		httpPost.addHeader("Accept", "application/json");
		httpPost.addHeader("Content-Type", "application/json");

		String portalUrl = Globals.FOX_PORTALURL + "/api/mber/chdrInfo.json";

		StringEntity params =new StringEntity("{\"esntlId\":\""+user.getUniqId()+"\"}");

		URI uri = new URIBuilder(portalUrl)
				.build();
		httpPost.setEntity(params);
		httpPost.setURI(uri);

		HttpClient httpClient = HttpClientBuilder.create().build();
		HttpResponse httpResponse = httpClient.execute(httpPost);

		String resultJson = EntityUtils.toString(httpResponse.getEntity());

		System.out.println("result : " + resultJson);

		ObjectMapper objectMapper = new ObjectMapper().configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		JsonResult jsonResult = objectMapper.readValue(resultJson, JsonResult.class);

		if (jsonResult.isSuccess()) {
			JSONObject jObj = JSONObject.fromObject(JSONSerializer.toJSON(resultJson));


			JSONObject data = (JSONObject) jObj.get("data");
			JSONArray jsonArray = (JSONArray) data.get("chdr");

			List<HashMap<String,String>> chdrList = new ArrayList<>();
			for(int i = 0; i < jsonArray.size();i++){
				HashMap<String,String> chdrMap = new HashMap<>();
				chdrMap.put("childEsntlId",jsonArray.getJSONObject(i).get("esntlId").toString());
				chdrMap.put("childNm",jsonArray.getJSONObject(i).get("mberNm").toString());
				chdrList.add(chdrMap);
			}
			System.out.println(chdrList);
			result.put("chdrArray",chdrList);
			result.setSuccess(true);

		}else{
			result.setSuccess(false);
		}
		return result;
		}
	}


