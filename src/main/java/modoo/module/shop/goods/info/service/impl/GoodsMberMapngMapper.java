package modoo.module.shop.goods.info.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import egovframework.rte.psl.dataaccess.util.EgovMap;

import java.util.List;

@Mapper("goodsMberMapngMapper")
public interface GoodsMberMapngMapper {

    void insertGoodsMberMapng(EgovMap map) throws Exception;

    void deleteGoodsMberMapngList(EgovMap map) throws Exception;

    List<String> selectGoodsMberMapngList(EgovMap map) throws Exception;
}
