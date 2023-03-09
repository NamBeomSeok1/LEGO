package modoo.module.system.log.conect.service;

import java.util.List;

public interface ConectLogService {
	

	/**
	 * B2C접속로그 목록
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	List<?> selectB2CConectCountList(ConectLogVO searchVO) throws Exception;

	/**
	 * B2B접속로그 목록
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	List<?> selectB2BConectCountList(ConectLogVO searchVO) throws Exception;

	/**
	 * 접속로그 저장
	 * @param conectLog
	 * @throws Exception
	 */
	void insertConectLog(ConectLogVO conectLog) throws Exception;
	
	/**
	 * 접속카운트 목록
	 * @param searchVO
	 * @return
	 * @throws Exception
	 */
	List<ConectLogVO> selectConectCountList(ConectLogVO searchVO) throws Exception;
}
