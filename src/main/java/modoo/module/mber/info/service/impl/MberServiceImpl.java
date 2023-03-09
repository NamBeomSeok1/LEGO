package modoo.module.mber.info.service.impl;

import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.net.URI;

import javax.annotation.Resource;

import modoo.module.common.util.APIUtil;
import net.sf.json.JSONSerializer;
import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.client.utils.URIBuilder;
import org.apache.http.impl.client.HttpClientBuilder;
import org.apache.http.util.EntityUtils;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.apache.http.impl.client.CloseableHttpClient;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import com.fasterxml.jackson.databind.DeserializationFeature;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.twelvemonkeys.lang.StringUtil;

import modoo.module.common.service.JsonResult;
import modoo.module.common.service.ModooUserDetailHelper;
import modoo.module.mber.agre.service.MberAgreService;
import modoo.module.mber.agre.service.MberAgreVO;
import modoo.module.mber.info.service.MberService;
import modoo.module.mber.info.service.MberVO;
import egovframework.com.cmm.service.Globals;
import egovframework.com.utl.fcc.service.EgovStringUtil;
import egovframework.com.utl.sim.service.EgovFileScrty;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("mberService")
public class MberServiceImpl extends EgovAbstractServiceImpl implements MberService {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(MberServiceImpl.class);
	
	@Resource(name = "mberMapper")
	private MberMapper mberMapper;
	
	@Resource(name = "MberIdGnrService")
	private EgovIdGnrService mberIdGnrService;
	
	@Resource(name = "mberAgreService")
	private MberAgreService mberAgreService;
	
	//TODO : 이주화 구성시 와스간에 mber권한 
	private List<MberVO> mberCachedAuthList = new ArrayList<MberVO>();
	
	/**
	 * 회원 목록
	 */
	@Override
	public List<?> selectMberList(MberVO searchVO) throws Exception {
		return mberMapper.selectMberList(searchVO);
	}

	/**
	 * 회원 목록 카운트
	 */
	@Override
	public int selectMberListCnt(MberVO searchVO) throws Exception {
		return mberMapper.selectMberListCnt(searchVO);
	}

	/**
	 * 회원 저장
	 */
	@Override
	public void insertMber(MberVO mber) throws Exception {
		String esntlId = mberIdGnrService.getNextStringId();
		mber.setEsntlId(esntlId);

		String encryptPassword = EgovFileScrty.encryptPassword(mber.getPassword(), mber.getMberId());
		mber.setPassword(encryptPassword);
		
		mberMapper.insertMber(mber);
		
		for(MberVO vo : this.mberCachedAuthList) {
			System.out.println("before : " + vo.getMberId() + "," + vo.getAuthorCode());
		}
		
		MberVO newMber = new MberVO();
		newMber.setMberId(mber.getMberTyCode() + mber.getMberId());
		newMber.setAuthorCode(mber.getAuthorCode());
		
		MberService mService =  ModooUserDetailHelper.getMberService();
		mService.addMberRole(newMber);

	}
	
	/**
	 * SSO 회원 저장
	 */
	@Override
	public String insertSsoMber(MberVO mber) throws Exception {
		String esntlId = mberIdGnrService.getNextStringId();
		mber.setEsntlId(esntlId);
		
		//패스워드 처리는 의미 없게 처리
		if(!"KAKAO".equals(mber.getClientCd()) && !"GOOGLE".equals(mber.getClientCd()) && !"APPLE".equals(mber.getClientCd()) && !"NAVER".equals(mber.getClientCd())){
			mber.setPassword("sso_user_pass"); //실제 패스워드가 아니고 NOT NULL 처리
		}
		
		//회원저장
		mberMapper.insertSsoMber(mber);
		
		MberVO newMber = new MberVO();
		newMber.setMberId(mber.getMberTyCode() + mber.getMberId());
		newMber.setAuthorCode(mber.getAuthorCode());
		
		MberService mService =  ModooUserDetailHelper.getMberService();
		mService.addMberRole(newMber);;
		
		return esntlId;
	}
	
	/**
	 * PORTAL 회원 저장 
	 */
	@Override
	public void insertPortalMber(MberVO mber) throws Exception {
		HttpPost httpPost = new HttpPost();
		httpPost.addHeader("Accept", "application/json");
		httpPost.addHeader("Content-Type", "application/json");
		
		String portalUrl = Globals.FOX_PORTALURL + "/api/mber/mberInfo.json";
		
		URI uri = new URIBuilder(portalUrl)
				.addParameter("esntlId", mber.getEsntlId())
				.build();
		httpPost.setURI(uri);
		
		HttpClient httpClient = HttpClientBuilder.create().build();
		HttpResponse httpResponse = httpClient.execute(httpPost);
		
		String resultJson = EntityUtils.toString(httpResponse.getEntity());
		
		System.out.println("result : " + resultJson);
		
		ObjectMapper objectMapper = new ObjectMapper().configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		JsonResult jsonResult = objectMapper.readValue(resultJson, JsonResult.class);
		
		if(jsonResult.isSuccess()) {
			JSONParser parser = new JSONParser();
			JSONObject obj = (JSONObject) parser.parse(resultJson);
			JSONObject data = (JSONObject) obj.get("data");
			JSONObject mberData = (JSONObject) data.get("mber");

			System.out.println("mber DATA: " +data.toString());
			
			mber.setEsntlId(mberData.get("esntlId").toString());
			mber.setMberId(mberData.get("mberId").toString());
			mber.setMberNm(mberData.get("mberNm").toString());
			mber.setMberTyCode(mberData.get("mberTyCode").toString());
			mber.setGroupId(mberData.get("groupId").toString());
			mber.setAuthorCode(mberData.get("authorCode").toString());
			mber.setMberSttus(mberData.get("mberSttus").toString());
			mber.setSiteId("SITE_00000");
			mber.setClientCd("PORTAL");


			if(mberData.get("siteId") != null){
				mber.setSiteId(mberData.get("siteId").toString());
			}

			if(mberData.get("sbscrbMberAt") != null) {
				mber.setSbscrbMberAt(mberData.get("sbscrbMberAt").toString());
			}
			if(mberData.get("email") != null) {
				mber.setEmail(mberData.get("email").toString());
			}
			if(mberData.get("profileImg") != null) {
				mber.setProfileImg(mberData.get("profileImg").toString());
			}
			if(mberData.get("brthdy") != null) {
				mber.setBirthday(mberData.get("brthdy").toString());
			}
			if(mberData.get("sexdstnCode") != null) {
				mber.setSexdstn(mberData.get("sexdstnCode").toString());
			}
			if(mberData.get("mbtlnumPre") != null && mberData.get("mbtlnumMiddle") != null && mberData.get("mbtlnumEnd") != null) {
				mber.setMoblphon(mberData.get("mbtlnumPre").toString() + "-" + mberData.get("mbtlnumMiddle").toString() + "-" + mberData.get("mbtlnumEnd").toString());
			}
			
			if(mber != null && !EgovStringUtil.isEmpty(mber.getEsntlId())) {
				mberMapper.insertPortalMber(mber);
			}
		}
	}
	
	/**
	 * 회원 상세
	 */
	@Override
	public MberVO selectMber(MberVO mber) throws Exception {
		return mberMapper.selectMber(mber);
	}

	@Override
	public void updateMber(MberVO mber) throws Exception {

		HashMap<String,String> map = new HashMap<>();
		map.put("esntlId",mber.getEsntlId());
		if(mber.getSbscrbMberAt()==null){
			map.put("sbscrbMberAt","N");
			this.updateSbsMberApi(map);
		}else{
			map.put("sbscrbMberAt","Y");
			this.updateSbsMberApi(map);
		}

		mberMapper.updateMber(mber);
	}

	/**
	 * 회원 수정
	 */
	@Override
	public void LoginUpdateMber(MberVO mber) throws Exception {

		HttpPost httpPost = new HttpPost();
		httpPost.addHeader("Accept", "application/json");
		httpPost.addHeader("Content-Type", "application/json");

		String portalUrl = Globals.FOX_PORTALURL + "/api/mber/mberInfo.json";

		URI uri = new URIBuilder(portalUrl)
				.addParameter("esntlId", mber.getEsntlId())
				.build();
		httpPost.setURI(uri);

		HttpClient httpClient = HttpClientBuilder.create().build();
		HttpResponse httpResponse = httpClient.execute(httpPost);

		String resultJson = EntityUtils.toString(httpResponse.getEntity());

		System.out.println("result : " + resultJson);

		ObjectMapper objectMapper = new ObjectMapper().configure(DeserializationFeature.FAIL_ON_UNKNOWN_PROPERTIES, false);
		JsonResult jsonResult = objectMapper.readValue(resultJson, JsonResult.class);

		if(jsonResult.isSuccess()) {
			JSONParser parser = new JSONParser();
			JSONObject obj = (JSONObject) parser.parse(resultJson);
			JSONObject data = (JSONObject) obj.get("data");
			JSONObject mberData = (JSONObject) data.get("mber");

			System.out.println("mber DATA: " +data.toString());

			mber.setMberId(mberData.get("mberId").toString());
			mber.setMberNm(mberData.get("mberNm").toString());
			mber.setMberTyCode(mberData.get("mberTyCode").toString());
			mber.setMberSttus(mberData.get("mberSttus").toString());

			if(mberData.get("sbscrbMberAt") != null) {
				mber.setSbscrbMberAt(mberData.get("sbscrbMberAt").toString());
			}
			if(mberData.get("siteId") != null) {
				mber.setSiteId(mberData.get("siteId").toString());
			}
			if(mberData.get("email") != null) {
				mber.setEmail(mberData.get("email").toString());
			}
			if(mberData.get("profileImg") != null) {
				mber.setProfileImg(mberData.get("profileImg").toString());
			}
			if(mberData.get("brthdy") != null) {
				mber.setBirthday(mberData.get("brthdy").toString());
			}
			if(mberData.get("sexdstnCode") != null) {
				mber.setSexdstn(mberData.get("sexdstnCode").toString());
			}
			if(mberData.get("mbtlnumPre") != null && mberData.get("mbtlnumMiddle") != null && mberData.get("mbtlnumEnd") != null) {
				mber.setMoblphon(mberData.get("mbtlnumPre").toString() + "-" + mberData.get("mbtlnumMiddle").toString() + "-" + mberData.get("mbtlnumEnd").toString());
			}

			if(mber != null && !EgovStringUtil.isEmpty(mber.getEsntlId())) {
				mberMapper.updateMber(mber);
			}
		}
	}

	/**
	 * 회원 상태 수정
	 */
	@Override
	public void updateMberSttus(MberVO mber) throws Exception {
		mberMapper.updateMberSttus(mber);
	}

	/**
	 * 회원 삭제
	 */
	@Override
	public void deleteMber(MberVO mber) throws Exception {
		mberMapper.deleteMber(mber);
	}

	/**
	 * 회원 ID 중복 카운트
	 */
	@Override
	public int selectCheckDuplMberIdCnt(MberVO mber) throws Exception {
		return mberMapper.selectCheckDuplMberIdCnt(mber);
	}

	/**
	 * 비밀번호 수정
	 */
	@Override
	public void updatePassword(MberVO mber) throws Exception {
		String encryptPassword = EgovFileScrty.encryptPassword(mber.getPassword(), mber.getMberId());
		mber.setPassword(encryptPassword);
		mberMapper.updatePassword(mber);
	}

	/**
	 * 잠김 해제
	 */
	@Override
	public void updateLockIncorrect(MberVO mber) throws Exception {
		mberMapper.updateLockIncorrect(mber);
	}

	/**
	 * SSO 회원가입체크
	 */
	@Override
	public int selectSsoMemberCheck(MberVO mber) throws Exception {
		return mberMapper.selectSsoMemberCheck(mber);
	}

	/**
	 * SSO 회원상세
	 */
	@Override
	public MberVO selectSsoMember(MberVO mber) throws Exception {
		return mberMapper.selectSsoMember(mber);
	}

	/**
	 * 회원권한 목록
	 */
	@Override
	public List<MberVO> selectMberAuthList() throws Exception {
		if(mberCachedAuthList.size() == 0)  {
			this.mberCachedAuthList = mberMapper.selectMberAuthList();
		}else {
			LOGGER.info("GET Cached : mberCachedAuthList ");
		}
		return this.mberCachedAuthList;
	}
	
	/**
	 * 이지웰 상태 수정
	 */
	@Override
	public void updateEzwelMember(MberVO mber) throws Exception {
		mberMapper.updateEzwelMember(mber);
	}

	@Override
	public void addMberRole(MberVO mber) throws Exception {
		this.mberCachedAuthList.add(mber);
	}

	/**
	 * 구독회원 전송 api
	 */
	public void updateSbsMberApi(HashMap<String,String> map) throws Exception{

		System.out.println("-------updateSbsMber start!!-----------");

		HashMap<String,String> resultMap = new HashMap<>();

		URL url = new URL(Globals.FOX_PORTALURL+"/api/mber/mberUpdate.json");

		net.sf.json.JSONObject jsonObject = new net.sf.json.JSONObject();

		jsonObject.put("esntlId",map.get("esntlId"));
		jsonObject.put("sbscrbMberAt",map.get("sbscrbMberAt"));

		String jsonString = APIUtil.postUrlBodyJson(url,jsonObject.toString());
		net.sf.json.JSONObject jObj = (net.sf.json.JSONObject) JSONSerializer.toJSON(jsonString);
		String success = jObj.getString("success");
		System.out.println(success);
		if("true".equals(success)){
			resultMap.put("successYn","Y");
		}else{
			String message = jObj.getString("message");
			System.out.println(message+"구독 회원 변경 실패!! ");
			resultMap.put("successYn","N");
			resultMap.put("message",message);
		}
	}



}
