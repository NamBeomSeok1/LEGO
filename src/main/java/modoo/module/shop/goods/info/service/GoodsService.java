package modoo.module.shop.goods.info.service;

import java.util.List;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import modoo.module.shop.goods.order.service.OrderVO;
import org.json.simple.JSONArray;

public interface GoodsService {

	/**
	 * 상품 목록
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	List<?> selectGoodsList(GoodsVO searchVO) throws Exception;

	/**
	 * 상품 목록 카운트
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	int selectGoodsListCnt(GoodsVO searchVO) throws Exception;

	/**
	 * 상품 저장
	 * @param searchVO
	 * @throws Exception
	 */
	void insertGoods(GoodsVO goods, JSONArray optArray) throws Exception;

    /**
	 * 상품 상세
	 * @param goods
	 * @return
	 * @throws Exception
	 */
	GoodsVO selectGoods(GoodsVO goods) throws Exception;

	/**
	 * 상품 수정
	 * @param goods
	 * @throws Exception
	 */
	void updateGoods(GoodsVO goods, JSONArray optArray) throws Exception;

	/**
	 * 상품 조회수 증분
	 * @param goods
	 * @throws Exception
	 */
	void updateGoodsRdcnt(GoodsVO goods) throws Exception;

	/**
	 * 상품 카테고리 순서 변경
	 * @param goods
	 * @throws Exception
	 */
	void updateGoodsCtgrySn(List<GoodsVO> goodsList) throws Exception;

	/**
	 * 상품 삭제
	 * @param goods
	 * @throws Exception
	 */
	void deleteGoods(GoodsVO goods) throws Exception;

	/**
	 * 상품 상태 카운트
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	EgovMap selectGoodsSttusCnt(GoodsVO searchVO) throws Exception;

	/**
	 * 베스트 상품 목록
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	List<?> selectBestGoodsList(GoodsVO searchVO) throws Exception;

	/**
	 * 베스트 상품 목록 카운트
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	int selectBestGoodsListCnt(GoodsVO searchVO) throws Exception;

	/**
	 * 제휴사매핑에 연결된 상품갯수
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	int selectPrtnrCmpnyGoodsListCnt(GoodsVO searchVO) throws Exception;
	/**
	 * 상품 등록 상태 일괄 변경
	 * @param goods
	 */
	void updateGoodsRegistSttus(GoodsVO goods);

	/**
	 * 메인 상품 목록
	 */
	List<?> selectMainGoodsList(GoodsVO searchVO) throws Exception;

	/**
	 * 전용 상품 목록
	 */
	List<?> selectPrvuseGoodsList(String mberId) throws Exception;

	/**
	 * 메인 상품 순서 최대값
	 */
	int selectMainGoodsMaxSn(GoodsVO searchVO) throws Exception;


	/**
	 * 메인 상품 목록 카운트
	 */
	int selectMainGoodsListCnt(GoodsVO searchVO) throws Exception;

	public List<GoodsVO> selectGoodsCount(EgovMap map) throws Exception;

}
