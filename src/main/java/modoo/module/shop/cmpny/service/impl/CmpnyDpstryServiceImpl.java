package modoo.module.shop.cmpny.service.impl;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import modoo.module.shop.cmpny.service.CmpnyDpstryService;
import modoo.module.shop.cmpny.service.CmpnyDpstryVO;
import modoo.module.shop.cmpny.service.CmpnyInqryService;
import modoo.module.shop.cmpny.service.CmpnyInqryVO;
import org.springframework.stereotype.Service;

import javax.annotation.Resource;
import java.util.List;

@Service("cmpnyDpstryService")
public class CmpnyDpstryServiceImpl extends EgovAbstractServiceImpl implements CmpnyDpstryService {


	@Resource(name="cmpnyDpstryMapper")
	private CmpnyDpstryMapper cmpnyDpstryMapper;

	@Override
	public List<CmpnyDpstryVO> selectCmpnyDpstryList(CmpnyDpstryVO searchVO) throws Exception {
		return cmpnyDpstryMapper.selectCmpnyDpstryList(searchVO);
	}

	@Override
	public void insertCmpnyDpstry(CmpnyDpstryVO cmpnyDpstryVO) throws Exception {
		cmpnyDpstryMapper.insertCmpnyDpstry(cmpnyDpstryVO);
	}

	@Override
	public void updateCmpnyDpstry(CmpnyDpstryVO cmpnyDpstryVO) throws Exception {
		cmpnyDpstryMapper.updateCmpnyDpstry(cmpnyDpstryVO);
	}

	@Override
	public int selectCmpnyDpstryListCnt(CmpnyDpstryVO searchVO) {
		return cmpnyDpstryMapper.selectCmpnyDpstryListCnt(searchVO);
	}

	@Override
	public void deleteCmpnyDpstry(CmpnyDpstryVO searchVO) throws Exception {
		cmpnyDpstryMapper.deleteCmpnyDpstry(searchVO);
	}
}
