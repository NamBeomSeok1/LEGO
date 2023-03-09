package modoo.module.shop.goods.label.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import modoo.module.shop.goods.label.service.GoodsLabelVO;

import java.util.List;

@Mapper("goodsLabelMapper")
public interface GoodsLabelMapper {

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
     * 상품 라벨 저장
     * @param goodsLabelVO
     * @throws Exception
     */
    void insertGoodsLabel(GoodsLabelVO goodsLabelVO) throws Exception;

    /**
     * 상품 라벨 삭제
     * @param goodsLabelVO
     * @throws Exception
     */
    void deleteGoodsLabel(GoodsLabelVO goodsLabelVO) throws Exception;
}
