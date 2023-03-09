package modoo.module.shop.goods.label.service.impl;

import modoo.module.shop.goods.label.service.GoodsLabelService;
import modoo.module.shop.goods.label.service.GoodsLabelVO;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("goodsLabelService")
public class GoodsLabelServiceImpl implements GoodsLabelService {

    @Resource(name="goodsLabelMapper")
    GoodsLabelMapper goodsLabelMapper;

    @Override
    public List<GoodsLabelVO> selectGoodsLabelList(GoodsLabelVO goodsLabelVO) throws Exception {
        return goodsLabelMapper.selectGoodsLabelList(goodsLabelVO);
    }

    @Override
    public GoodsLabelVO selectGoodsLabel(GoodsLabelVO goodsLabelVO) throws Exception {
        return goodsLabelMapper.selectGoodsLabel(goodsLabelVO);
    }

    @Override
    public void deleteGoodsLabel(GoodsLabelVO goodsLabelVO) throws Exception {
        goodsLabelMapper.deleteGoodsLabel(goodsLabelVO);
    }
}
