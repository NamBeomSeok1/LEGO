package modoo.module.sale.service.impl;

import java.util.List;
import java.util.stream.Collectors;

import javax.annotation.Resource;
import javax.transaction.Transactional;

import egovframework.rte.psl.dataaccess.util.EgovMap;
import modoo.module.shop.goods.label.service.GoodsLabelVO;
import modoo.module.shop.goods.label.service.impl.GoodsLabelMapper;
import org.springframework.stereotype.Service;

import modoo.module.best.service.BestService;
import modoo.module.best.service.impl.BestVO;
import modoo.module.sale.service.SaleService;

@Service("saleService")
public class SaleServiceImpl implements SaleService {
	
	@Resource(name = "saleMapper")
	private SaleMapper saleMapper;

	@Resource(name = "goodsLabelMapper")
	private GoodsLabelMapper goodsLabelMapper;

	@Transactional
	@Override
	public void saveSaleGoods(SaleVO searchVO, List<SaleVO> saleList) {
		saleMapper.deleteSaleGoods(searchVO);
		for (SaleVO saleGoods : saleList) {
			System.out.println(saleGoods.toString());
			saleMapper.insertSaleGoods(saleGoods);
		}
	}

	@Override
	public List<?> selectSaleGoodsList(SaleVO searchVO) {
		List<EgovMap> resultList = (List<EgovMap>) saleMapper.selectSaleGoodsList(searchVO);

		try {
			for (EgovMap e : resultList) {

				GoodsLabelVO goodsLabelVO = new GoodsLabelVO();
				goodsLabelVO.setGoodsId(String.valueOf(e.get("goodsId")));

				List<GoodsLabelVO> labelList = goodsLabelMapper.selectGoodsLabelList(goodsLabelVO);
				if (labelList.size() > 0) {
					e.put("labelUseAt", "Y");

					List<GoodsLabelVO> mainLabelList = labelList.stream()
							.filter(s -> s.getLabelMainChk() != null)
							.filter(s -> s.getLabelMainChk().equals("Y"))
							.collect(Collectors.toList());

					e.put("goodsMainLabelList", mainLabelList);

					labelList = labelList.stream()
							.filter(s -> !"Y".equals(s.getLabelMainChk()))
							.collect(Collectors.toList());

					e.put("goodsLabelList", labelList);

					//썸네일 메인 라벨

				}
			}
		}catch (Exception e){
			e.printStackTrace();
		}

		return resultList;

	}

}
