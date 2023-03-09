package modoo.module.shop.cmpny.service;

import java.util.List;

public interface CmpnyDpstryService {
	/**
	 * 보관소 리스트
	 */
	List<CmpnyDpstryVO> selectCmpnyDpstryList(CmpnyDpstryVO searchVO) throws Exception;

	/**
	 *보관소 등록
	 */
	void insertCmpnyDpstry(CmpnyDpstryVO cmpnyInqry) throws Exception;

	/**
	 *보관소 등록
	 */
	void updateCmpnyDpstry(CmpnyDpstryVO cmpnyInqry) throws Exception;

	/**
	 *보관소 삭제
	 */
	void deleteCmpnyDpstry(CmpnyDpstryVO cmpnyDpstryVO) throws Exception;

	/**
	 * 보관소 리스트 갯수
	 * @param searchVO
	 * @return
	 */
	int selectCmpnyDpstryListCnt(CmpnyDpstryVO searchVO) throws Exception;

}
