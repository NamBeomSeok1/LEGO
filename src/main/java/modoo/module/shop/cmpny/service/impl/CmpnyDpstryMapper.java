package modoo.module.shop.cmpny.service.impl;

import egovframework.rte.psl.dataaccess.mapper.Mapper;
import modoo.module.shop.cmpny.service.CmpnyDpstryVO;

import java.util.List;

@Mapper("cmpnyDpstryMapper")
public interface CmpnyDpstryMapper {

 /**
  * 보관소 리스트
  */
  List<CmpnyDpstryVO> selectCmpnyDpstryList(CmpnyDpstryVO searchVO) throws Exception;

  /**
   *보관소 등록
   */
  void insertCmpnyDpstry(CmpnyDpstryVO cmpnyDpstryVO) throws Exception;

  /**
   *보관소 수정
   */
  void updateCmpnyDpstry(CmpnyDpstryVO cmpnyDpstryVO) throws Exception;

  /**
   *보관소 삭제
   */
  void deleteCmpnyDpstry(CmpnyDpstryVO cmpnyDpstryVO) throws Exception;
  /**
   * 보관소 리스트 갯수
   * @param searchVO
   * @return
   */
  int selectCmpnyDpstryListCnt(CmpnyDpstryVO searchVO);


}
