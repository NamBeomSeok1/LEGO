package modoo.module.board.service.impl;

import java.io.File;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.annotation.Resource;

import egovframework.com.cmm.service.EgovFileMngService;
import egovframework.com.cmm.service.FileVO;
import egovframework.com.cmm.service.impl.FileManageDAO;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import modoo.module.common.service.FileMngUtil;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import modoo.module.board.service.BoardArticleService;
import modoo.module.board.service.BoardArticleVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;

@Service("boardArticleService")
public class BoardArticleServiceImpl extends EgovAbstractServiceImpl implements BoardArticleService {
	
	@Resource(name = "boardArticleMapper")
	private BoardArticleMapper boardArticleMapper;

	@Resource(name = "FileManageDAO")
	private FileManageDAO fileMngDAO;

	@Resource(name = "bbsNttIdGnrService")
	private EgovIdGnrService bbsNttIdGnrService;

	/**
	 * 게시물 목록
	 */
	@Override
	public List<?> selectBoardArticleList(BoardArticleVO searchVO) throws Exception {

		List<EgovMap> resultList = (List<EgovMap>) boardArticleMapper.selectBoardArticleList(searchVO);

		if("Y".equals(searchVO.getFrontAt())
			&& resultList.size() > 0
			&& ("BBSMSTR_000000000001".equals(searchVO.getBbsId()) || "BBSMSTR_000000000003".equals(searchVO.getBbsId()))){

			List<HashMap<Integer,List<EgovMap>>> list = new ArrayList<>();
			HashSet<Integer> validSet = new HashSet<>();

			for(EgovMap e : resultList){
				HashMap<Integer,List<EgovMap>> tmpMap = new HashMap<>();
				Integer ctgryId = Integer.valueOf((String)e.get("ctgryId"));

				if(validSet.contains(ctgryId)) {
					continue;
				}

				List<EgovMap> tmpList = resultList.stream()
								.filter(a->ctgryId.equals(Integer.valueOf((String)a.get("ctgryId"))))
								.collect(Collectors.toList());

				validSet.add(ctgryId);
				tmpMap.put(ctgryId,tmpList);
				list.add(tmpMap);
			}
			return list;
		}

		return resultList;
	}

	/**
	 * 게시물 목록 카운트
	 */
	@Override
	public int selectBoardArticleListCnt(BoardArticleVO searchVO) throws Exception {
		return boardArticleMapper.selectBoardArticleListCnt(searchVO);
	}

	@Override
	public List<String> selectCtgryIdList(BoardArticleVO searchVO) throws Exception {
		return boardArticleMapper.selectCtgryIdList(searchVO);
	}

	/**
	 * 공지사항 목록
	 */
	@Override
	public List<?> selectBoardArticleNoticeList(BoardArticleVO searchVO) throws Exception {
		return boardArticleMapper.selectBoardArticleNoticeList(searchVO);
	}

	/**
	 * 게시물 저장
	 */
	@Override
	public void insertBoardArticle(BoardArticleVO article) throws Exception {
		Long nttId = bbsNttIdGnrService.getNextLongId();
		article.setNttId(nttId);

		//답글 여부
		if("Y".equals(article.getReplyAt())) {
			boardArticleMapper.insertReplyBoardArticle(article);

			// 계층형 
			long nttNo = boardArticleMapper.getParentNttNo(article);

			//같은 sortOrdr 글의 NTT_NO 1씩증가
			article.setNttNo(nttNo);
			boardArticleMapper.updateOtherNttNo(article);
			
			article.setNttNo(nttNo + 1);
			boardArticleMapper.updateNttNo(article);
		}else {
			article.setParntscttNo(0L);
			article.setReplyLc(0);
			article.setReplyAt("N");
			boardArticleMapper.insertBoardArticle(article);
		}
	}

	/**
	 * 게시물 상세
	 */
	@Override
	public BoardArticleVO selectBoardArticle(BoardArticleVO article) throws Exception {

		article = boardArticleMapper.selectBoardArticle(article);

		return article;
	}

	/**
	 * 게시물 수정
	 */
	@Override
	public void updateBoardArticle(BoardArticleVO article) throws Exception {
		boardArticleMapper.updateBoardArticle(article);
	}

	/**
	 * 게시물 삭제
	 */
	@Override
	public void deleteBoardArticle(BoardArticleVO article) throws Exception {
		boardArticleMapper.deleteBoardArticle(article);
	}

}
