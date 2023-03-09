package modoo.module.shop.goods.info.service.impl;

import java.util.List;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import modoo.module.shop.goods.info.service.GoodsCouponVO;
import modoo.module.shop.goods.info.service.GoodsVO;
import modoo.module.shop.goods.order.service.OrderVO;

@Mapper("goodsMapper")
public interface GoodsMapper {

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
	void insertGoods(GoodsVO goods) throws Exception;

	/**
	 * 상품 아이템기본 정보 저장
	 * @param searchVO
	 * @throws Exception
	 */
	void insertGoodsItemInfo(GoodsVO goods) throws Exception;

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
	void updateGoods(GoodsVO goods) throws Exception;

	/**
	 * 상품 조회수 증분
	 * @param goods
	 * @throws Exception
	 */
	void updateGoodsRdcnt(GoodsVO goods) throws Exception;

	/**
	 * 상품 카테고리 증분
	 * @param goods
	 * @throws Exception
	 */
	void updateGoodsCtgrySn(GoodsVO goods) throws Exception;

	/**
	 * 상품 판매수 수정
	 * @param goods
	 * @throws Exception
	 */
	void updateGoodsSleCo(GoodsVO goods) throws Exception;

	/**
	 * 상품 판매수 목록 수정
	 * @param orderGroupNo
	 */
	void updateGoodsListSleCo(java.math.BigDecimal orderGroupNo) throws Exception;

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
	 * @param searchvO
	 * @return
	 * @throws Exception
	 */
	int selectBestGoodsListCnt(GoodsVO searchvO) throws Exception;

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
	 * @param searchvO
	 * @return
	 * @throws Exception
	 */
	List<?> selectMainGoodsList(GoodsVO searchVO) throws Exception;

	/**
	 * 전용 상품 목록
	 * @param mberId
	 * @return
	 * @throws Exception
	 */
	List<?> selectPrvuseGoodsList(String mberId) throws Exception;


	/**
	 * 메인 상품 순서 최대값
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	int selectMainGoodsMaxSn(GoodsVO searchVO) throws Exception;

	/**
	 * 메인 상품 목록 카운트
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	int selectMainGoodsListCnt(GoodsVO searchVO) throws Exception;

	List<GoodsVO> selectChkGoodsList(EgovMap map)throws Exception;

}
