package modoo.module.shop.goods.info.service;

import egovframework.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

public interface GoodsItemService {

	/**
	 * 상품항목 목록
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	List<GoodsItemVO> selectGoodsItemList(GoodsItemVO searchVO) throws Exception;

	/**
	 * 상품항목 삭제
	 * @param goodsItem
	 * @throws Exception
	 */
	void deleteGoodsItem(GoodsItemVO goodsItem) throws Exception;

	List<GoodsItemVO> selectOptnValues(EgovMap paramMap) throws Exception;


}
