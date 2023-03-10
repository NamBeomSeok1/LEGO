package modoo.module.common.web;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLEncoder;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import egovframework.com.cmm.EgovMessageSource;
import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.EgovFileMngUtil;
import egovframework.com.cmm.service.FileVO;
import egovframework.com.cmm.util.EgovResourceCloseHelper;
import egovframework.com.cmm.util.EgovUserDetailsHelper;
import modoo.module.common.service.FileMngUtil;
import modoo.module.common.service.JsonResult;
import modoo.module.common.util.CommonUtils;

@Controller
public class FileMngController extends CommonDefaultController {

	private static final Logger LOGGER = LoggerFactory.getLogger(FileMngController.class);
	
	/** EgovMessageSource */
	@Resource(name = "egovMessageSource")
	protected EgovMessageSource egovMessageSource;
			
	@Resource(name = "EgovFileMngService")
	private EgovFileMngService fileMngService;
	
	@Resource(name = "fileMngUtil")
	private FileMngUtil fileMngUtil;
	
	
	/**
	 * ?????? ??????
	 * @param fileSearchVO
	 * @param paramAtchFileId
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fms/seletFileList.do")
	public String selectFileList(@ModelAttribute("file") FileVO fileSearchVO,
			@RequestParam(value = "paramAtchFileId", required = false) String paramAtchFileId,
			@ModelAttribute(value = "updateFlag") String updateFlag,
			@ModelAttribute(value = "downloadAt") String downloadAt,
			Model model) throws Exception {
		
		fileSearchVO.setAtchFileId(paramAtchFileId);
		List<FileVO> resultList = fileMngService.selectFileInfs(fileSearchVO);
		model.addAttribute("resultList", resultList);
		
		return "modoo/common/fms/fileList";
	}
	
	/**
	 * ????????? ?????? ?????? ??????
	 * @param fileSearchVO
	 * @param paramAtchFileId
	 * @param updateFlag
	 * @param downloadAt
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/shop/fms/selectFileList.do")
	public String shopSelectFileList(@ModelAttribute("file") FileVO fileSearchVO,
			@RequestParam(value = "paramAtchFileId", required = false) String paramAtchFileId,
			Model model) throws Exception {
		
		fileSearchVO.setAtchFileId(paramAtchFileId);
		List<FileVO> resultList = fileMngService.selectFileInfs(fileSearchVO);
		model.addAttribute("resultList", resultList);
		
		return "modoo/common/fms/shopFileList";
	}
	
	/**
	 * ????????? ?????? ??????
	 * @param fileSearchVO
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/fms/imageFileList.do")
	public String imageFileList(@ModelAttribute("file") FileVO fileSearchVO, Model model) throws Exception {
		
		List<FileVO> resultList = fileMngService.selectFileInfs(fileSearchVO);
		model.addAttribute("resultList", resultList);
		return "modoo/common/fms/imageFileList";
	}
	
	/**
	 * ????????? ???
	 * @param atchFileId
	 * @param fileSn
	 * @param response
	 * @throws Exception
	 */
	@RequestMapping(value = "/fms/getImage.do")
	public void getImage(@RequestParam("atchFileId") String atchFileId,
			@RequestParam("fileSn") String fileSn, HttpServletRequest request, 
			HttpServletResponse response) throws Exception {
		
		FileVO fileVO = new FileVO();
		fileVO.setAtchFileId(atchFileId);
		fileVO.setFileSn(fileSn);
		
		fileVO = fileMngService.selectFileInf(fileVO);
		
		File file = null;
		FileInputStream fis = null;
		BufferedInputStream in = null;
		ByteArrayOutputStream bStream = null;
		
		try {
			file = new File(fileVO.getFileStreCours(), fileVO.getStreFileNm());
			
			if(!file.exists()) {
				LOGGER.info("????????? ???????????? ????????????." + file.getPath());
				String noneFilePath = request.getServletContext().getRealPath("/") + "/resources/decms/common/image/no-image.png";
				noneFilePath = noneFilePath.replaceAll("\\\\","/");
				file = new File(noneFilePath);
			}
			
			fis = new FileInputStream(file);
			in = new BufferedInputStream(fis);
			bStream = new ByteArrayOutputStream();
			int imgByte;
			while ((imgByte = in.read()) != -1) {
				bStream.write(imgByte);
			}

			String type = "";

			if (StringUtils.isNotEmpty(fileVO.getFileExtsn())) {
				if ("jpg".equals(fileVO.getFileExtsn().toLowerCase())) {
					type = "image/jpeg";
				} else {
					type = "image/" + fileVO.getFileExtsn().toLowerCase();
				}
			} else {
				LOGGER.debug("Image fileType is null.");
			}

			response.setHeader("Content-Type", type);
			response.setContentLength(bStream.size());

			bStream.writeTo(response.getOutputStream());

			response.getOutputStream().flush();
			response.getOutputStream().close();
		}catch(Exception e) {
			LOGGER.debug("", e);
		}finally{
			if (bStream != null) {
				try {
					bStream.close();
				} catch (Exception est) {
					LOGGER.debug("IGNORED: {}", est.getMessage());
				}
			}
			if (in != null) {
				try {
					in.close();
				} catch (Exception ei) {
					LOGGER.debug("IGNORED: {}", ei.getMessage());
				}
			}
			if (fis != null) {
				try {
					fis.close();
				} catch (Exception efis) {
					LOGGER.debug("IGNORED: {}", efis.getMessage());
				}
			}
		}
		
	}
	
	/**
	 * ?????? ????????????
	 * @param request
	 * @param response
	 * @param fileVO
	 * @throws Exception
	 */
	@RequestMapping(value = "/fms/downloadFile.do")
	public void downloadFile(HttpServletRequest request, HttpServletResponse response, FileVO fileVO) throws Exception {
		FileVO fvo = fileMngService.selectFileInf(fileVO);
		
		File uFile = new File(fvo.getFileStreCours(), fvo.getStreFileNm());
		long fSize = uFile.length();
		
		if(fSize > 0) {
			/*String mimeType = "application/x-msdownload";*/
			String mimeType = "application/octet-stream";

			response.setContentType(mimeType);
			setDisposition(fvo.getOrignlFileNm(), request, response);
			
			BufferedInputStream in = null;
			BufferedOutputStream out = null;
			
			try {
				in = new BufferedInputStream(new FileInputStream(uFile));
				out = new BufferedOutputStream(response.getOutputStream());
				
				FileCopyUtils.copy(in, out);
				out.flush();
			}catch(IOException ex) {
				LOGGER.info("IO Exception");
			}finally {
				EgovResourceCloseHelper.close(in, out);
			}
			
		}else {
			response.setContentType("application/x-msdownload");

			PrintWriter printwriter = response.getWriter();
			
			printwriter.println("<html>");
			printwriter.println("<br><br><br><h2>Could not get file name:<br>" + fvo.getOrignlFileNm() + "</h2>");
			printwriter.println("<br><br><br><center><h3><a href='javascript: history.go(-1)'>Back</a></h3></center>");
			printwriter.println("<br><br><br>&copy; webAccess");
			printwriter.println("</html>");
			
			printwriter.flush();
			printwriter.close();
		}
	}
	
	/**
	 * ?????? ??????
	 * @param file
	 * @return
	 */
	@RequestMapping(value = "/fms/deleteFile.json", method = RequestMethod.POST)
	@ResponseBody
	public JsonResult deleteFile(FileVO file) {
		JsonResult jsonResult = new JsonResult();
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		try {
			
			if(!isAuthenticated) {
				this.vaildateMessage(egovMessageSource.getMessage("cms.fail.access"), jsonResult); // ????????? ???????????????.
				LOGGER.error("?????? ?????? ?????? : ????????? ");
			}else if(StringUtils.isEmpty(file.getAtchFileId()) || StringUtils.isEmpty(file.getFileSn())) {
				this.vaildateMessage(egovMessageSource.getMessage("cms.fail.access"), jsonResult); // ????????? ???????????????.
				LOGGER.error("atchFileId ?????? fileSn ??? ?????? ");
			}else {
				
				fileMngService.deleteFileInf(file);
				
				jsonResult.setSuccess(true);
				jsonResult.setMessage(egovMessageSource.getMessage("success.common.delete")); //??????????????? ?????????????????????.
			}
			
		} catch(Exception e) {
			LOGGER.error("Exception : " + e);
			jsonResult.setSuccess(false);
			jsonResult.setMessage(egovMessageSource.getMessage("fail.common.delete")); //????????? ?????????????????????.
		}
		
		return jsonResult;
	}
	
	@RequestMapping(value = "/fms/imageUpload.do")
	public @ResponseBody Map<String, Object> imageUpload(final MultipartHttpServletRequest multiRequest,
														@RequestParam(value = "atchFileId", required = false) String atchFileId,
														HttpSession session, HttpServletResponse response) throws Exception {
		Map<String, Object> map = new HashMap<String, Object>();
		JsonResult jsonResult = new JsonResult();
		
		Boolean isAuthenticated = EgovUserDetailsHelper.isAuthenticated();
		if(isAuthenticated) {		
			Map<String, Object> fileInfo = new HashMap<String, Object>();
			
			final List<MultipartFile> files = multiRequest.getFiles("file");
			if(!files.isEmpty()) {
				String prefixPath = "EDITOR" + File.separator + "CNTNTS";
				if(StringUtils.isEmpty(atchFileId)) {
					List<FileVO> result = fileMngUtil.parseFileInf(files, "IMG_", 0, "" , "", prefixPath);
					String fileId = fileMngService.insertFileInfs(result);
					jsonResult.setSuccess(true);
					//fileInfo.put("url", "/fms/getImage.do?atchFileId=" + fileId + "&fileSn=0");
					//fileInfo.put("atchFileId", fileId);
					jsonResult.put("url", "/fms/getImage.do?atchFileId=" + fileId + "&fileSn=0");
				}else {
					FileVO fvo = new FileVO();
					fvo.setAtchFileId(atchFileId);
					int cnt = fileMngService.getMaxFileSN(fvo);
					List<FileVO> result = fileMngUtil.parseFileInf(files, "IMG_", cnt, atchFileId, "", prefixPath);
					fileMngService.updateFileInfs(result);
					jsonResult.setSuccess(true);
					//fileInfo.put("url", "/fms/getImage.do?atchFileId=" + atchFileId + "&fileSn=" + cnt);
					//fileInfo.put("atchFileId", atchFileId);
					jsonResult.put("url", "/fms/getImage.do?atchFileId=" + atchFileId + "&fileSn=" + cnt);
				}
				
			}else {
				jsonResult.setMessage("????????? ????????? ????????????!");
			}
		}else {
			jsonResult.setMessage("???????????? ???????????????!");
		}
		map.put("result", jsonResult);
		return map;
	}
	
	/**
	 * Disposition ??????
	 * @param filename
	 * @param request
	 * @param response
	 * @throws Exception
	 */
	private void setDisposition(String filename, HttpServletRequest request, HttpServletResponse response) throws Exception {
		String browser = CommonUtils.getBrowser(request);

		String dispositionPrefix = "attachment; filename=";
		String encodedFilename = null;

		if (browser.equals("MSIE")) {
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Trident")) { // IE11 ????????? ?????? ??????
			encodedFilename = URLEncoder.encode(filename, "UTF-8").replaceAll("\\+", "%20");
		} else if (browser.equals("Firefox")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Opera")) {
			encodedFilename = "\"" + new String(filename.getBytes("UTF-8"), "8859_1") + "\"";
		} else if (browser.equals("Chrome")) {
			StringBuffer sb = new StringBuffer();
			for (int i = 0; i < filename.length(); i++) {
				char c = filename.charAt(i);
				if (c > '~') {
					sb.append(URLEncoder.encode("" + c, "UTF-8"));
				} else {
					sb.append(c);
				}
			}
			encodedFilename = sb.toString();
		} else {
			throw new IOException("Not supported browser");
		}

		response.setHeader("Content-Disposition", dispositionPrefix + encodedFilename);

		if ("Opera".equals(browser)) {
			response.setContentType("application/octet-stream;charset=UTF-8");
		}
	}
	
}
