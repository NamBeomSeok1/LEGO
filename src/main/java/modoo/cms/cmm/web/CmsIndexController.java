package modoo.cms.cmm.web;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import modoo.module.common.web.CommonDefaultController;
import egovframework.com.cmm.LoginVO;
import egovframework.com.cmm.util.EgovUserDetailsHelper;

@Controller
public class CmsIndexController extends CommonDefaultController {

	@RequestMapping(value = "/decms/index.do")
	public String index(Model model) throws Exception {
		
		LoginVO user = (LoginVO)EgovUserDetailsHelper.getAuthenticatedUser();
		model.addAttribute("USER", user);
		
		/*return "modoo/cms/cmm/index";*/
		return "redirect:/decms/board/master/boardMasterManage.do?menuId=boardMaster";
	}
}
	