package modoo.cms.shop.cmpny.web;

import java.util.List;

import javax.annotation.Resource;
import javax.validation.Valid;

import modoo.module.shop.cmpny.service.*;
import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;

import egovframework.com.cmm.ComDefaultCodeVO;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.service.EgovCmmUseService;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import egovframework.com.uat.uia.service.EgovLoginService;
import egovframework.com.utl.fcc.service.EgovDateUtil;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import egovframework.rte.ptl.mvc.tags.ui.pagination.PaginationInfo;
import modoo.module.common.service.JsonResult;
import modoo.module.common.util.SiteDomainHelper;
import modoo.module.common.web.CommonDefaultController;
import modoo.module.mber.info.service.MberService;
import modoo.module.mber.info.service.MberVO;
import modoo.module.shop.bank.service.BankService;
import modoo.module.shop.bank.service.BankVO;
import modoo.module.shop.goods.brand.service.GoodsBrandService;
import modoo.module.shop.goods.info.service.GoodsService;
import modoo.module.shop.goods.info.service.GoodsVO;
import modoo.module.shop.hdry.service.HdryCmpnyService;
import modoo.module.shop.hdry.service.HdryCmpnyVO;

@Controller
public class CmsCmpnyController extends CommonDefaultController {
	
	private static final Logger LOGGER = LoggerFactory.getLogger(CmsCmpnyController.class);
	
	private static final String EZW_PRTNR_ID = "PRTNR_0001";
	
	@Resource(name = "cmpnyService")
	private CmpnyService cmpnyService;
	
	/** EgovCmmUseService */
	@Resource(name = "EgovCmmUseService")
	private EgovCmmUseService cmmUseService;
	
	@Resource(name = "bankService")
	private BankService bankService;
	
	@Resource(name = "hdryCmpnyService")
	private HdryCmpnyService hdryCmpnyService;
	
	@Resource(name = "mberService")
	private MberService mberService;
	
	@Resource(name = "goodsService")
	private GoodsService goodsService;
	
	@Resource(name = "prtnrService")
	private PrtnrService prtnrService;
	
	@Resource(name = "prtnrCmpnyService")
	private PrtnrCmpnyService prtnrCmpnyService;
	
	@Resource(name = "loginService")
	private EgovLoginService loginService;
	
	@Resource(name = "goodsBrandService")
	private GoodsBrandService goodsBrandService;

	@Resource(name = "cmpnyDpstryService")
	private CmpnyDpstryService cmpnyDpstryService ;
	
	
	/**
	 * ?????? ??????
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/decms/shop/cmpny/cmpnyManage.do")
	public String cmpnyManage(@ModelAttribute("searchVO") CmpnyVO searchVO, Model model) throws Exception {
		
		//?????? ?????? ????????? ????????? 
		if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) {
			return "redirect:/decms/index.do";
		}
		
		if(StringUtils.isEmpty(searchVO.getSearchBgnde())) {
			searchVO.setSearchBgnde(EgovDateUtil.addMonth(EgovDateUtil.getToday(),-3));
		}
		
		if(StringUtils.isEmpty(searchVO.getSearchEndde())) {
			searchVO.setSearchEndde(EgovDateUtil.getToday());
		}

		return "modoo/cms/shop/cmpny/cmpnyManage";
	}
	
	/**
	 * ????????????
	 * @param searchVO
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/cmpny/cmpnyList.json")
	@ResponseBody
	public JsonResult cmpnyList(CmpnyVO searchVO) {
		JsonResult jsonResult = new JsonResult();
		
		try {
			//?????? ?????? ????????? ????????? 
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) {
				jsonResult.setMessage(egovMessageSource.getMessage("cms.fail.accessDenied")); //?????? ????????? ????????????.
				jsonResult.setSuccess(false);
			}else {
				if(StringUtils.isNotEmpty(searchVO.getSearchBgnde())) {
					searchVO.setSearchBgnde(EgovDateUtil.validChkDate(searchVO.getSearchBgnde()));
				}
				if(StringUtils.isNotEmpty(searchVO.getSearchEndde())) {
					searchVO.setSearchEndde(EgovDateUtil.validChkDate(searchVO.getSearchEndde()));
				}
				
				PaginationInfo paginationInfo = new PaginationInfo();
				searchVO.setPageUnit(propertiesService.getInt("gridPageUnit"));
				this.setPagination(paginationInfo, searchVO);
				
				List<?> resultList = cmpnyService.selectCmpnyList(searchVO);
				jsonResult.put("list", resultList);
				
				int totalRecordCount = cmpnyService.selectCmpnyListCnt(searchVO);
				paginationInfo.setTotalRecordCount(totalRecordCount);
				jsonResult.put("paginationInfo", paginationInfo);
				
				jsonResult.setSuccess(true);
			}
			
		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.select")); //????????? ?????????????????????.
		}
		
		return jsonResult;
	}
	
	/**
	 * ?????? ?????? ??????
	 * @param searchVO
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/cmpny/cmpnyAllList.json")
	@ResponseBody
	public JsonResult cmpnyAllList(CmpnyVO searchVO) {
		JsonResult jsonResult = new JsonResult();
		
		try {
			//????????? ????????? ????????? 
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) {
				jsonResult.setMessage(egovMessageSource.getMessage("cms.fail.accessDenied")); //?????? ????????? ????????????.
				jsonResult.setSuccess(false);
			}else {
				List<?> resultList = cmpnyService.selectCmpnyAllList(searchVO);
				jsonResult.put("list", resultList);
				
				jsonResult.setSuccess(true);
			}
		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.select")); //????????? ?????????????????????.
		}
		
		return jsonResult;
	}
	
	/**
	 * ???????????? ???
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/decms/shop/cmpny/writeCmpny.do")
	public String writeCmpny(@ModelAttribute("searchVO") CmpnyVO searchVO,
			@RequestParam(value = "menuId") String menuId, Model model) throws Exception {
		
		//?????? ?????? ????????? ????????? 
		if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) {
			return "redirect:/decms/index.do";
		}
		
		// ????????? ??????
//		PrtnrVO prtnr = new PrtnrVO();
//		List<PrtnrVO> prtnrList = prtnrService.selectPrtnrList(prtnr);
//		model.addAttribute("prtnrList", prtnrList);

		// ????????????????????? ??????
		ComDefaultCodeVO codeVO = new ComDefaultCodeVO();
		codeVO.setCodeId("CMS005");
		List<?> stdeSeCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("stdeSeCodeList", stdeSeCodeList);
		
		//????????? ?????????????????? ??????
		codeVO.setCodeId("CMS006");
		List<?> splpcSeCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("splpcSeCodeList", splpcSeCodeList);
		
		//?????????????????? ??????
		codeVO.setCodeId("CMS007");
		List<?> opnngSttusCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("opnngSttusCodeList", opnngSttusCodeList); 
		
		//????????????
		BankVO bank = new BankVO();
		List<BankVO> bankList = bankService.selectBankList(bank);
		model.addAttribute("bankList", bankList);
		
		//???????????????
		HdryCmpnyVO hdryCmpny = new HdryCmpnyVO();
		List<?> hdryCmpnyList = hdryCmpnyService.selectHdryCmpnyList(hdryCmpny);
		model.addAttribute("hdryCmpnyList", hdryCmpnyList);

		//????????? ??????
		CmpnyDpstryVO cmpnyDpstryVO = new CmpnyDpstryVO();
		cmpnyDpstryVO.setCmpnyId(searchVO.getCmpnyId());
		List<CmpnyDpstryVO> cmpnyDpstryList = cmpnyDpstryService.selectCmpnyDpstryList(cmpnyDpstryVO);
		model.addAttribute("dpstryList",cmpnyDpstryList);
		
		CmpnyVO cmpny = new CmpnyVO();
		cmpny.setOpnngDe(EgovDateUtil.getToday()); //?????????
		cmpny.setSplpcSeCode("SP01"); // ???????????? ????????? ?????? (??????)
		cmpny.setOpnngSttusCode("R"); // ????????????
		cmpny.setPrtnrId(EZW_PRTNR_ID); // ????????? ????????????
		cmpny.setStdeSeCode("STDE04"); //?????? ?????? 2020.10.07 ????????? ?????? ??????
		cmpny.setPrtnrCmpnyList(prtnrCmpnyService.selectPrtnrCmpnyList(new PrtnrCmpnyVO())); // ????????? ??????
		cmpny.setRtngudDlvyPc(java.math.BigDecimal.ZERO); //?????? ?????????
		cmpny.setExchngDlvyPc(java.math.BigDecimal.ZERO); //?????? ?????????
		model.addAttribute("cmpny", cmpny);
		

		return "modoo/cms/shop/cmpny/cmpnyForm";
	}
	
	/**
	 * ?????? ?????? ????????? ?????? ????????????
	 * @param cmpny
	 */
	private void trimCmpnyInfoValue(CmpnyVO cmpny) {
		cmpny.setCmpnyNm(cmpny.getCmpnyNm().trim());
		cmpny.setBizrno(cmpny.getBizrno().trim());
		cmpny.setChargerEmail(cmpny.getChargerEmail().trim());
	}
	
	/**
	 * ????????????
	 * @param cmpny
	 * @param bindingResult
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/cmpny/writeCmpny.json")
	@ResponseBody
	public JsonResult writeCmpny(@Valid CmpnyVO cmpny, BindingResult bindingResult,
			@RequestParam(value = "menuId") String menuId) {
		JsonResult jsonResult = new JsonResult();
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		try {
			this.trimCmpnyInfoValue(cmpny);
			
			//????????? ????????? ????????? 
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) {
				jsonResult.setMessage(egovMessageSource.getMessage("cms.fail.accessDenied")); //?????? ????????? ????????????.
				jsonResult.setSuccess(false);
			}else if(!this.isHasErrorsJson(bindingResult, jsonResult, "<br/>")) {
				
				
				if(StringUtils.isEmpty(cmpny.getCmpnyUserEsntlId())) {
					this.vaildateMessage(egovMessageSource.getMessage("NotEmpty.cmpnyVO.cmpnyUserEsntlId"), jsonResult); // ???????????? ???????????????.
				}else if(cmpny.getHdryCmpnyList() == null || cmpny.getHdryCmpnyList().size() == 0) {
					jsonResult.setMessage("??????????????? ???????????????!"); 
					jsonResult.setSuccess(false);
				}else {
					int pcCnt = 0;
					for(PrtnrCmpnyVO pc : cmpny.getPrtnrCmpnyList()) {
						if(StringUtils.isNotEmpty(pc.getUseAt()) && "Y".equals(pc.getUseAt())) {
							pcCnt++;
						}
					}
					
					if(pcCnt == 0) {
						jsonResult.setMessage("??????????????? ???????????????!"); 
						jsonResult.setSuccess(false);
						return jsonResult;
					}
					
					MberVO mber = new MberVO();
					mber.setMberId(cmpny.getCmpnyMberId());
					/*
					//??????ID ????????????
					if(StringUtils.isEmpty(cmpny.getCmpnyUserEsntlId())) {
						
						//???????????? ?????? ??????
						if(cmpny.getCmpnyMberPassword().length() < 8 || cmpny.getCmpnyMberPassword().length() > 20) {
							this.vaildateMessage(egovMessageSource.getMessage("Length.cmpnyVO.cmpnyMberPassword"), jsonResult); // ??????????????? 8????????? 20??? ????????? ???????????????.
							return jsonResult;
						}
						
						//??????ID ??????
						//mber.setMberId(cmpny.getCmpnyMberId());
						if(mberService.selectCheckDuplMberIdCnt(mber) > 0) {
							this.vaildateMessage(egovMessageSource.getMessage("mberVO.fail.useMberId"), jsonResult); //?????? ????????? ID ?????????.
							return jsonResult;
						}
					}else { //??????ID ??????
						if(mberService.selectCheckDuplMberIdCnt(mber) == 0) {
							this.vaildateMessage(egovMessageSource.getMessage("mberVO.fail.notExistMberId"), jsonResult); //???????????? ?????? ????????? ID ?????????.
							return jsonResult;
						}
					}
					*/
					
					if(mberService.selectCheckDuplMberIdCnt(mber) == 0) {
						this.vaildateMessage(egovMessageSource.getMessage("mberVO.fail.notExistMberId"), jsonResult); //???????????? ?????? ????????? ID ?????????.
						return jsonResult;
					}
					
					String bizrno = cmpny.getBizrno().replaceAll("[^0-9]", "");
					
					CmpnyVO svo = new CmpnyVO();
					svo.setSearchCondition("EQ_NM");
					svo.setSearchKeyword(cmpny.getCmpnyNm());
					if(cmpnyService.selectCmpnyListCnt(svo) > 0) {
						this.vaildateMessage(egovMessageSource.getMessage("cmpny.fail.existCmpnyNm"), jsonResult); //?????? ???????????? ????????? ?????????.
					}else if(cmpnyService.selectCmpnyBizrnoCheckCnt(cmpny) > 0) {
						this.vaildateMessage(egovMessageSource.getMessage("cmpny.fail.existBizrno"), jsonResult); //?????? ???????????? ????????????????????? ?????????.
					}else {
						cmpny.setBizrno(bizrno);
						cmpny.setOpnngDe(EgovDateUtil.validChkDate(cmpny.getOpnngDe()));
						cmpny.setFrstRegisterId(user.getUniqId());
						
						cmpnyService.insertCmpny(cmpny);
						
						//????????? ?????? ?????? ??????
						goodsBrandService.reloadGoodsBrandGroupList();
						
						String redirectUrl = "/decms/shop/cmpny/cmpnyManage.do?menuId=" + menuId;
						jsonResult.setRedirectUrl(redirectUrl);
						jsonResult.setSuccess(true);
						jsonResult.setMessage(egovMessageSource.getMessage("success.common.insert")); //??????????????? ?????????????????????.
					
					}
					
				}
			}
			
		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.insert")); //????????? ?????????????????????.
		}
		
		return jsonResult;
	}
	
	/**
	 * ???????????? ???
	 * @param searchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/decms/shop/cmpny/modifyCmpny.do")
	public String modifyCmpny(@ModelAttribute("searchVO") CmpnyVO searchVO,
			@RequestParam(value = "menuId") String menuId, Model model) throws Exception {
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE") && StringUtils.isNotEmpty(user.getCmpnyId())) {
			searchVO.setCmpnyId(user.getCmpnyId());
		}else if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE") && StringUtils.isEmpty(user.getCmpnyId())) {
			model.addAttribute("errorMessage", "????????????????????? ???????????? ???????????????.");
			model.addAttribute("errorRedirectUrl", "/decms/index.do");
			return "modoo/common/error/error";
		}
		
		// ????????? ??????
//		PrtnrVO prtnr = new PrtnrVO();
//		List<PrtnrVO> prtnrList = prtnrService.selectPrtnrList(prtnr);
//		model.addAttribute("prtnrList", prtnrList);
				
		// ????????????????????? ??????
		ComDefaultCodeVO codeVO = new ComDefaultCodeVO();
		codeVO.setCodeId("CMS005");
		List<?> stdeSeCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("stdeSeCodeList", stdeSeCodeList);
		
		//????????? ?????????????????? ??????
		codeVO.setCodeId("CMS006");
		List<?> splpcSeCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("splpcSeCodeList", splpcSeCodeList);
		
		//?????????????????? ??????
		codeVO.setCodeId("CMS007");
		List<?> opnngSttusCodeList = cmmUseService.selectCmmCodeDetail(codeVO);
		model.addAttribute("opnngSttusCodeList", opnngSttusCodeList); 
		
		//????????????
		BankVO bank = new BankVO();
		List<BankVO> bankList = bankService.selectBankList(bank);
		model.addAttribute("bankList", bankList);
		
		//???????????????
		HdryCmpnyVO hdryCmpny = new HdryCmpnyVO();
		List<?> hdryCmpnyList = hdryCmpnyService.selectHdryCmpnyList(hdryCmpny);
		model.addAttribute("hdryCmpnyList", hdryCmpnyList);

		//????????? ??????
		CmpnyDpstryVO cmpnyDpstryVO = new CmpnyDpstryVO();
		cmpnyDpstryVO.setCmpnyId(searchVO.getCmpnyId());
		List<CmpnyDpstryVO> cmpnyDpstryList = cmpnyDpstryService.selectCmpnyDpstryList(cmpnyDpstryVO);
		model.addAttribute("dpstryList",cmpnyDpstryList);
		
		CmpnyVO cmpny = cmpnyService.selectCmpny(searchVO);
		String bizrno = cmpny.getBizrno();
		if(bizrno.length() == 10) {
			bizrno = bizrno.substring(0,3) + "-" + bizrno.substring(3,5) + "-" + bizrno.substring(5,10);
			cmpny.setBizrno(bizrno);
		}
		model.addAttribute("cmpny", cmpny);
		
		//?????? ?????????
		GoodsVO goods = new GoodsVO();
		goods.setSearchCmpnyId(cmpny.getCmpnyId());
		EgovMap goodsSttusCnt = goodsService.selectGoodsSttusCnt(goods);
		model.addAttribute("goodsSttusCnt", goodsSttusCnt);

		return "modoo/cms/shop/cmpny/cmpnyForm";
	}

	/**
	 * ????????????
	 * @param cmpny
	 * @param bindingResult
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/cmpny/modifyCmpny.json")
	@ResponseBody
	public JsonResult modifyCmpny(
			CmpnyVO searchVO,
			@Valid CmpnyVO cmpny, BindingResult bindingResult,
			@RequestParam(value = "menuId") String menuId) {
		JsonResult jsonResult = new JsonResult();
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		try {
			this.trimCmpnyInfoValue(cmpny);
			
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) {
				CmpnyVO checkVO = cmpnyService.selectCmpny(cmpny);
				if(!checkVO.getCmpnyId().equals(user.getCmpnyId())) { // ROLE_SHOP ?????? ????????? ?????? ????????? ?????????
					jsonResult.setMessage(egovMessageSource.getMessage("cms.fail.accessDenied")); //?????? ????????? ????????????.
					jsonResult.setSuccess(false);
					return jsonResult;
				}
				
				//????????? ??????????????? ????????? ????????? ??????
				cmpny.setCmpnyId(checkVO.getCmpnyId()); // ????????????ID
				cmpny.setCmpnyUserEsntlId(checkVO.getCmpnyUserEsntlId()); //???????????????ID
				cmpny.setOpnngSttusCode(checkVO.getOpnngSttusCode()); // ???????????????????????????
				cmpny.setPrtnrCmpnyList(checkVO.getPrtnrCmpnyList()); // ?????????
				cmpny.setStdeSeCode(checkVO.getStdeSeCode()); //?????????
				
			}
			
			if(cmpny.getHdryCmpnyList() == null || cmpny.getHdryCmpnyList().size() == 0) {
				jsonResult.setMessage("??????????????? ???????????????!"); 
				jsonResult.setSuccess(false);
			}else if(!this.isHasErrorsJson(bindingResult, jsonResult, "<br/>")) {
				
				int pcCnt = 0;
				for(PrtnrCmpnyVO pc : cmpny.getPrtnrCmpnyList()) {
					if(StringUtils.isNotEmpty(pc.getUseAt()) && "Y".equals(pc.getUseAt())) {
						pcCnt++;
					}
				}
				
				if(pcCnt == 0) {
					jsonResult.setMessage("??????????????? ???????????????!"); 
					jsonResult.setSuccess(false);
					return jsonResult;
				}
				
				if(StringUtils.isEmpty(cmpny.getCmpnyId())) {
					this.vaildateMessage(egovMessageSource.getMessage("cms.fail.access"), jsonResult); // ????????? ???????????????.
					LOGGER.error("cmpnyId ??? ??????.");
				}else {
					String bizrno = cmpny.getBizrno().replaceAll("[^0-9]", "");
					cmpny.setBizrno(bizrno);
					
					if(cmpnyService.selectCmpnyBizrnoCheckCnt(cmpny) > 0) {
						this.vaildateMessage(egovMessageSource.getMessage("cmpny.fail.existBizrno"), jsonResult); // ?????? ???????????? ????????????????????? ?????????.
					}else {
					
						cmpny.setOpnngDe(EgovDateUtil.validChkDate(cmpny.getOpnngDe()));
						cmpny.setLastUpduserId(user.getUniqId());

						cmpnyService.updateCmpny(cmpny);
						
						//????????? reload
						goodsBrandService.reloadGoodsBrandGroupList();
						
						String redirectUrl = "/decms/shop/cmpny/cmpnyManage.do?menuId=" + menuId
								+ "&searchCondition=" + searchVO.getSearchCondition()
								+ "&searchKeyword=" + searchVO.getSearchKeyword()
								+ "&searchBgnde=" + searchVO.getSearchBgnde()
								+ "&searchEndde=" + searchVO.getSearchEndde()
								+ "&pageIndex=" + searchVO.getPageIndex();
						jsonResult.setRedirectUrl(redirectUrl);
						jsonResult.setSuccess(true);
						jsonResult.setMessage(egovMessageSource.getMessage("success.common.update")); //??????????????? ?????????????????????.
					}
				}
			}
			
		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.update")); //????????? ?????????????????????.
		}
		
		return jsonResult;
	}
	
	/**
	 * ??????????????? ??????
	 * @param searchVO
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/cmpny/cmpnyMberList.json")
	@ResponseBody
	public JsonResult cmpnyMberList(MberVO searchVO) {
		JsonResult jsonResult = new JsonResult();
		
		try {
			if(StringUtils.isEmpty(searchVO.getSiteId())) {
				searchVO.setSearchSiteId(SiteDomainHelper.getSiteId());
			}
			
			PaginationInfo paginationInfo = new PaginationInfo();
			searchVO.setPageUnit(propertiesService.getInt("gridPageUnit"));
			this.setPagination(paginationInfo, searchVO);
			
			List<?> resultList = cmpnyService.selectCmpnyMberList(searchVO);
			jsonResult.put("list", resultList);
			
			int totalRecordCount = cmpnyService.selectCmpnyMberListCnt(searchVO);
			paginationInfo.setTotalRecordCount(totalRecordCount);
			jsonResult.put("paginationInfo", paginationInfo);
			
			jsonResult.setSuccess(true);
			
		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.select")); //????????? ?????????????????????.
		}
		
		return jsonResult;
	}


	/**
	 * ?????????(???????????????) ?????? 
	 * @param searchVO
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/cmpny/cmpnyDpstryList.json")
	@ResponseBody
	public JsonResult cmpnyDpstryList(CmpnyDpstryVO searchVO) {
		JsonResult jsonResult = new JsonResult();

		try {
			if(StringUtils.isEmpty(searchVO.getCmpnyId())) {
				searchVO.setCmpnyId(null);
			}

			List<?> resultList = cmpnyDpstryService.selectCmpnyDpstryList(searchVO);
			jsonResult.put("list", resultList);

			jsonResult.setSuccess(true);

		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.select")); //????????? ?????????????????????.
		}

		return jsonResult;
	}

	/**
	 * ?????????(???????????????) ??????
	 * @param searchVO
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/cmpny/cmpnyDpstryInsert.json")
	@ResponseBody
	public JsonResult cmpnyDpstryInsert(CmpnyDpstryVO searchVO) {
		JsonResult jsonResult = new JsonResult();

		try {

			if(searchVO.getDpstryZip().length() > 5){
				jsonResult.setSuccess(false);
				jsonResult.setMessage("??????????????? ????????? ??????????????????.");
				return jsonResult;
			}

			if(searchVO.getDpstryNo()!=null)
				cmpnyDpstryService.updateCmpnyDpstry(searchVO);
			else
				cmpnyDpstryService.insertCmpnyDpstry(searchVO);

			jsonResult.setSuccess(true);

		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.insert")); //????????? ?????????????????????.
		}
		return jsonResult;
	}

	/**
	 * ?????????(???????????????) ??????
	 * @param searchVO
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/cmpny/cmpnyDpstryDelete.json")
	@ResponseBody
	public JsonResult cmpnyDpstryDelete(CmpnyDpstryVO searchVO) {
		JsonResult jsonResult = new JsonResult();

		try {
			cmpnyDpstryService.deleteCmpnyDpstry(searchVO);

			jsonResult.setSuccess(true);

		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.delete")); //????????? ?????????????????????.
		}
		return jsonResult;
	}

	/**
	 * ?????? ????????? ???????????? ?????????
	 * @param cmpny
	 * @return
	 */
	/*@RequestMapping(value = "/decms/shop/cmpny/initPasswordUser.json")
	@ResponseBody
	public JsonResult initPasswordUser(CmpnyVO cmpny) {
		JsonResult jsonResult = new JsonResult();
		
		try {
			if(StringUtils.isEmpty(cmpny.getCmpnyUserEsntlId()) || StringUtils.isEmpty(cmpny.getCmpnyMberId())) {
				this.vaildateMessage(egovMessageSource.getMessage("cms.fail.access"), jsonResult); // ????????? ???????????????.
				LOGGER.error("EsntlId or mberId ??? ??????.");
			}else if(StringUtils.isEmpty(cmpny.getCmpnyMberPassword())) {
				this.vaildateMessage(egovMessageSource.getMessage("NotEmpty.mberVO.password"), jsonResult); //??????????????? ???????????????!
			}else {
				
				cmpnyService.initCmpnyMberPassword(cmpny);

				jsonResult.setSuccess(true);
				jsonResult.setMessage(egovMessageSource.getMessage("success.common.update")); //??????????????? ?????????????????????.
			}
		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.request.msg")); //??????????????? ?????????????????????.
		}
		
		return jsonResult;
		
	}*/
	
	/**
	 * ?????? ???????????? ??????
	 * @param cmpny
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/cmpny/changeSttusCode.json")
	@ResponseBody
	public JsonResult changeSttusCode(CmpnyVO cmpny) {
		JsonResult jsonResult = new JsonResult();
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		try {
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) {
				jsonResult.setMessage(egovMessageSource.getMessage("cms.fail.accessDenied")); //?????? ????????? ????????????.
				jsonResult.setSuccess(false);
				return jsonResult;
			}
			
			if(StringUtils.isEmpty(cmpny.getCmpnyId())) {
				this.vaildateMessage(egovMessageSource.getMessage("cms.fail.access"), jsonResult); // ????????? ???????????????.
				LOGGER.error("cmpnyId ??? ??????.");
			}else {
				cmpny.setLastUpduserId(user.getUniqId());
				cmpnyService.updateHdryCmpnySttusCode(cmpny);

				jsonResult.setSuccess(true);
				jsonResult.setMessage(egovMessageSource.getMessage("success.common.update")); //??????????????? ?????????????????????.
			}
		
		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.request.msg")); //??????????????? ?????????????????????.
			
		}
		return jsonResult;
	}
	
	/**
	 * ?????? ??????
	 * @param cmpny
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/cmpny/deleteCmpny.json", method = RequestMethod.POST)
	@ResponseBody
	public JsonResult deleteCmpny(CmpnyVO cmpny, @RequestParam(value = "menuId") String menuId) {
		JsonResult jsonResult = new JsonResult();
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		try {
			if(!EgovUserDetailsHelper.getAuthorities().contains("ROLE_EMPLOYEE")) {
				jsonResult.setMessage(egovMessageSource.getMessage("cms.fail.accessDenied")); //?????? ????????? ????????????.
				jsonResult.setSuccess(false);
				return jsonResult;
			}
			
			if(StringUtils.isEmpty(cmpny.getCmpnyId())) {
				
			}else {
				cmpny.setLastUpduserId(user.getUniqId());
				cmpnyService.deleteCmpny(cmpny);
				
				jsonResult.setSuccess(true);
				jsonResult.setMessage(egovMessageSource.getMessage("success.common.delete")); //??????????????? ?????????????????????.
				
				String redirectUrl = "/decms/shop/cmpny/cmpnyManage.do?menuId=" + menuId;
				jsonResult.setRedirectUrl(redirectUrl);
				
			}
			
		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.delete")); //????????? ?????????????????????.
		}
		
		return jsonResult;
	}
	
	/**
	 * ?????? ???????????? ??????
	 * @param mber
	 * @param model
	 * @return
	 */
	@RequestMapping(value = "/decms/shop/cmpny/cmpnyUserPwdChange.do")
	@ResponseBody
	public JsonResult cmpnyUserPwdChange(MberVO mber, String oldPassword, Model model) {
		JsonResult jsonResult = new JsonResult();
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		
		try {

			if(StringUtils.isEmpty(oldPassword)) {
			}else if(StringUtils.isEmpty(mber.getPassword())) {
				jsonResult.setMessage("?????? ??????????????? ???????????????"); 
				jsonResult.setSuccess(false);
			}else if(StringUtils.isEmpty(mber.getRepassword())) {
				jsonResult.setMessage("????????????????????? ???????????????"); 
				jsonResult.setSuccess(false);
			}else if(!mber.getPassword().equals(mber.getRepassword())) {
				jsonResult.setMessage("??????????????? ????????????????????? ????????????."); 
				jsonResult.setSuccess(false);
			}else {
				
				LoginVO checkVO = new LoginVO();
				checkVO.setId(user.getId());
				checkVO.setPassword(oldPassword);
				checkVO = loginService.actionLogin(checkVO);
				
				if (checkVO != null && checkVO.getId() != null && !checkVO.getId().equals("")) {
					mber.setMberId(user.getId());
					mberService.updatePassword(mber);

					jsonResult.setSuccess(true);
					jsonResult.setMessage(egovMessageSource.getMessage("success.common.update")); //??????????????? ?????????????????????.
				}else {
					jsonResult.setMessage("?????? ??????????????? ???????????????!"); 
					jsonResult.setSuccess(false);
				}
			}

		} catch(Exception e) {
			loggerError(LOGGER, e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.request.msg")); //??????????????? ?????????????????????.
			
		}
		return jsonResult;
	}


}
