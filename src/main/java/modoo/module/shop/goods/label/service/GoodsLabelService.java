package modoo.module.shop.goods.label.service;

import egovframework.rte.psl.dataaccess.mapper.Mapper;

import java.util.List;

public interface GoodsLabelService {

    /**
     * 상품라벨 목록
     * @param goodsLabelVO
     * @return
     * @throws Exception
     */
    List<GoodsLabelVO> selectGoodsLabelList(GoodsLabelVO goodsLabelVO) throws Exception;


    /**
     * 상품 라벨
     * @param goodsLabelVO
     * @return
     * @throws Exception
     */
    GoodsLabelVO selectGoodsLabel(GoodsLabelVO goodsLabelVO) throws Exception;

    /**
     * 상품 라벨 삭제
     * @param goodsLabelVO
     * @throws Exception
     */
    void deleteGoodsLabel(GoodsLabelVO goodsLabelVO) throws Exception;
}
