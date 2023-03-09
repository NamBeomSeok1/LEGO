package modoo.module.shop.goods.cart.service.impl;

import java.math.BigDecimal;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import javax.annotation.Resource;

import modoo.module.shop.cmpny.service.CmpnyDpstryVO;
import modoo.module.shop.cmpny.service.impl.CmpnyDpstryMapper;
import modoo.module.shop.goods.info.service.GoodsService;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;
import egovframework.rte.fdl.idgnr.EgovIdGnrService;
import egovframework.rte.psl.dataaccess.util.EgovMap;
import modoo.module.shop.goods.cart.service.CartItem;
import modoo.module.shop.goods.cart.service.CartService;
import modoo.module.shop.goods.cart.service.CartVO;
import modoo.module.shop.goods.info.service.GoodsItemVO;
import modoo.module.shop.goods.info.service.GoodsVO;
import modoo.module.shop.goods.info.service.impl.GoodsItemMapper;
import modoo.module.shop.goods.info.service.impl.GoodsMapper;

@Service("cartService")
public class CartServiceImpl extends EgovAbstractServiceImpl implements CartService {
	
	@Resource(name = "cartMapper")
	private CartMapper cartMapper;

	@Resource(name = "goodsMapper")
	private GoodsMapper goodsMapper;
	
	@Resource(name = "cartIdGnrService")
	private EgovIdGnrService cartIdGnrService;
	
	@Resource(name = "cartItemIdGnrService")
	private EgovIdGnrService cartItemIdGnrService;
	
	@Resource(name = "goodsItemMapper")
	private GoodsItemMapper goodsItemMapper;

	@Resource(name="cmpnyDpstryMapper")
	private CmpnyDpstryMapper cmpnyDpstryMapper;

	@Resource(name = "cartGroupIdGnrService")
	private EgovIdGnrService cartGroupIdGnrService;


	/**
	 * 장바구니 목록
	 */
	@Override
	public List<EgovMap> selectCartList(CartVO searchVO) throws Exception {
		List<EgovMap> cartList = cartMapper.selectCartList(searchVO);

		//List<CartVO> cartGroup = cartMapper.selectGroupGoodsInfo(searchVO);

		for(EgovMap cart: cartList) {
			CartItem cartItem = new CartItem();
			cartItem.setCartNo((BigDecimal) cart.get("cartNo"));
			List<CartItem>  cartItemList = cartMapper.selectCartItemList(cartItem);
			cart.put("cartItemList", cartItemList);
			
			//업쳉요청사항 목록
			GoodsItemVO goodsItem = new GoodsItemVO();
			goodsItem.setGoodsId((String) cart.get("goodsId"));
			goodsItem.setGitemSeCode("Q");	
			List<GoodsItemVO> goodsItemList = goodsItemMapper.selectGoodsItemList(goodsItem);
			cart.put("goodsItemList", goodsItemList);
			
			//상품정보
			GoodsVO goods = new GoodsVO();
			goods.setGoodsId((String)cart.get("goodsId"));
			goods=goodsMapper.selectGoods(goods);
			cart.put("goods", goods);
			//수강권 상품여부(구독권,심리코칭권)
			if(StringUtils.isNotEmpty(goods.getVchCode()))
			{
				cart.put("isVch","Y");
			}

			//픽업리스트 목록
			if("Y".equals(goods.getDpstryAt())){
				CmpnyDpstryVO cmpnyDpstryVO = new CmpnyDpstryVO();
				System.out.println(Arrays.stream(goods.getDpstryNoList().split(",")).collect(Collectors.toList()));
				cmpnyDpstryVO.setSearchDpstryNoList(Arrays.stream(goods.getDpstryNoList().split(",")).collect(Collectors.toList()));
				List<CmpnyDpstryVO> dpstryList = cmpnyDpstryMapper.selectCmpnyDpstryList(cmpnyDpstryVO);
				cart.put("dpstryList",dpstryList);
			}

		}
		
		return cartList;
	}

	public List<EgovMap> selectCartList2(CartVO searchVO) throws Exception {
		//List<EgovMap> cartList = cartMapper.selectCartList(searchVO);

		List<EgovMap> groupGoodsList = cartMapper.selectGroupGoodsInfo(searchVO);

		for(EgovMap groupGoods: groupGoodsList) {
			CartVO tempVo = new CartVO();
			tempVo.setCartGroupNo(new BigDecimal(groupGoods.get("cartGroupNo").toString()));
			tempVo.setSearchOrdrrId(searchVO.getSearchOrdrrId());
			tempVo.setCartAddAt(searchVO.getCartAddAt());
			List<EgovMap> cartList = cartMapper.selectCartList(tempVo);


			if(cartList.size() != 0){
				for(EgovMap cartEgov : cartList){
					CartItem cartItem = new CartItem();
					cartItem.setCartNo((BigDecimal) cartEgov.get("cartNo"));
					List<CartItem>  cartItemList = cartMapper.selectCartItemList(cartItem);
					cartEgov.put("cartItemList", cartItemList);
				}
				groupGoods.put("cartList", cartList);
			}


			if(StringUtils.isNotEmpty(groupGoods.get("vchCode").toString()))
			{
				groupGoods.put("isVch","Y");
			}


			//픽업리스트 목록
			if("Y".equals(groupGoods.get("dpstryAt"))){
				CmpnyDpstryVO cmpnyDpstryVO = new CmpnyDpstryVO();
				cmpnyDpstryVO.setSearchDpstryNoList(Arrays.stream(groupGoods.get("dpstryNoList").toString().split(",")).collect(Collectors.toList()));
				List<CmpnyDpstryVO> dpstryList = cmpnyDpstryMapper.selectCmpnyDpstryList(cmpnyDpstryVO);
				groupGoods.put("dpstryList",dpstryList);
			}

		}

		return groupGoodsList;
	}

	/**
	 * 장바구니 목록 카운트
	 */
	@Override
	public int selectCartListCnt(CartVO searchVO) throws Exception {
		return cartMapper.selectCartListCnt(searchVO);
	}
	
	/**
	 * 장바구니 상세
	 */
	@Override
	public EgovMap selectCart(CartVO searchVO) throws Exception {
		
		EgovMap cart = cartMapper.selectCart(searchVO);
		//카트 아이템 리스트 
		CartItem cartItem = new CartItem();
		cartItem.setCartNo((BigDecimal)cart.get("cartNo"));
		List<CartItem> cartItemList = cartMapper.selectCartItemList(cartItem);
		for(CartItem c : cartItemList){
			if(c.getGitemSeCode().equals("D")){
			cart.put("ditem", c);
			}else if(c.getGitemSeCode().equals("A")){
			cart.put("aitem", c);
			}else if(c.getGitemSeCode().equals("F")){
			cart.put("fitem", c);
			}
		}
		
		//카트 상품정보
		GoodsVO goods = new GoodsVO();
		goods.setGoodsId((String)cart.get("goodsId"));
		goods=goodsMapper.selectGoods(goods);
		cart.put("goods", goods);
		
		//상품 아이템 리스트
		GoodsItemVO goodsItem = new GoodsItemVO();
		goodsItem.setGoodsId((String)cart.get("goodsId"));
		goodsItem.setGitemSeCode("D");
		List<GoodsItemVO> doptList = goodsItemMapper.selectGoodsItemList(goodsItem);
		cart.put("dopt", doptList);
		goodsItem.setGitemSeCode("A");
		List<GoodsItemVO> aoptList = goodsItemMapper.selectGoodsItemList(goodsItem);
		cart.put("aopt", aoptList);
		goodsItem.setGitemSeCode("F");
		List<GoodsItemVO> foptList = goodsItemMapper.selectGoodsItemList(goodsItem);
		cart.put("fopt", foptList);
		return cart;
	}

	@Override
	public List<EgovMap> selectCart2(CartVO searchVO) throws Exception {
		List<EgovMap> cartGroupList = this.selectCartList2(searchVO);
		return cartGroupList;
	}


	/**
	 * 장바구니 저장
	 */
	@Override
	public java.math.BigDecimal insertCart(CartVO cart) throws Exception {


		java.math.BigDecimal cartGroupNo = cartGroupIdGnrService.getNextBigDecimalId();
		EgovMap tempMap = new EgovMap();
		tempMap.put("cartGroupNo", cartGroupNo);
		cartMapper.insertCartGroup(tempMap);

		//장바구니 추가 항목 저장
		if(cart.getCartVoList() != null && cart.getCartVoList().size() > 0){
			for(CartVO tempCart : cart.getCartVoList()) {
				java.math.BigDecimal cartNo = cartIdGnrService.getNextBigDecimalId();
				tempCart.setCartGroupNo(cartGroupNo);
				tempCart.setCartNo(cartNo);
				tempCart.setOrdrrId(cart.getOrdrrId());
				tempCart.setSearchOrdrrId(cart.getSearchOrdrrId());
				if(tempCart.getOrderCo() == null){
					tempCart.setOrderCo(0);
				}
				tempCart.setdOptnType(cart.getdOptnType());
				if("SBS".equals(cart.getGoodsKndCode()))tempCart.setOrderCo(1);
				tempCart.setCartAddAt(cart.getCartAddAt());
				//자녀정보
				cartMapper.insertCart(tempCart);

				if(tempCart.getCartItemIdList()!=null && tempCart.getCartItemIdList().size()>0){
					for(String id : tempCart.getCartItemIdList()){
						if(StringUtils.isNotEmpty(id)){
							GoodsItemVO goodsItem = new GoodsItemVO();
							CartItem cartItem = new CartItem();
							java.math.BigDecimal cartItemNo = cartItemIdGnrService.getNextBigDecimalId();
							goodsItem.setGitemId(id);
							goodsItem=goodsItemMapper.selectGoodsItem(goodsItem);
							cartItem.setCartItemNo(cartItemNo);
							cartItem.setCartNo(tempCart.getCartNo());
							cartItem.setGitemId(id);
							cartItem.setGitemNm(goodsItem.getGitemNm());
							cartItem.setGitemPc(goodsItem.getGitemPc());
							cartItem.setGitemSeCode(goodsItem.getGitemSeCode());
							cartMapper.insertCartItem(cartItem);
						}
					}
				}

				if(tempCart.getCartItemList() != null && tempCart.getCartItemList().size() > 0) {
					for(CartItem item : tempCart.getCartItemList()) {
						item.setCartItemNo(cartItemIdGnrService.getNextBigDecimalId());
						item.setCartNo(tempCart.getCartNo());
						item.setGitemCo(item.getGitemCo());
						cartMapper.insertCartItem(item);
					}
				}
			}
		}

		return cartGroupNo;
	}

	@Override
	public void updateCartClose(CartVO cart) throws Exception {
		cartMapper.updateCartClose(cart);
	}

	@Override
	public void updateCartGroupClose(CartVO cart) throws Exception {
		cartMapper.updateCartGroupClose(cart);
	}

	//장바구니 수정
	@Override
	public void updateCart(CartVO cart) throws Exception {
		
		GoodsItemVO goodsItem = new GoodsItemVO();
		CartItem cartItem = new CartItem(); 
		
		cartItem.setCartNo(cart.getCartNo());
		cartMapper.deleteCartItem(cartItem);

		if(cart.getCartItemIdList()!=null && cart.getCartItemIdList().size()>0){
			for(String id:cart.getCartItemIdList()){
				if(StringUtils.isNotEmpty(id)){
					java.math.BigDecimal cartItemNo = cartItemIdGnrService.getNextBigDecimalId();
					goodsItem.setGitemId(id);
					goodsItem=goodsItemMapper.selectGoodsItem(goodsItem);
					cartItem.setCartItemNo(cartItemNo);
					cartItem.setCartNo(cart.getCartNo());
					cartItem.setGitemId(id);
					cartItem.setGitemNm(goodsItem.getGitemNm());
					cartItem.setGitemPc(goodsItem.getGitemPc());
					cartItem.setGitemSeCode(goodsItem.getGitemSeCode());
					cartMapper.insertCartItem(cartItem);
				}
			}
		}
		
		cartMapper.updateCart(cart);
	}


	public void updateCart2(CartVO cart) throws Exception {
		//기존옵션 수정
		cartMapper.deleteCart(cart);
		if(cart.getCartItemList() != null && cart.getCartItemList().size() > 0){
			for(CartItem tempItemp :  cart.getCartItemList()){
				cartMapper.updateCartItem(tempItemp);
			}
		}

		//신규추가 옵션
		if(cart.getCartVoList() != null && cart.getCartVoList().size() > 0){
			for(CartVO tempCart : cart.getCartVoList()) {
				tempCart.setCartGroupNo(cart.getCartGroupNo());
				tempCart.setCartNo(cartIdGnrService.getNextBigDecimalId());
				tempCart.setOrdrrId(cart.getOrdrrId());
				tempCart.setSearchOrdrrId(cart.getSearchOrdrrId());
				if(cart.getdOptnType()!=null)tempCart.setdOptnType(cart.getdOptnType());
				if(tempCart.getOrderCo() == null){
					tempCart.setOrderCo(0);
				}
				if("SBS".equals(cart.getGoodsKndCode()))tempCart.setOrderCo(1);
				tempCart.setCartAddAt("Y");
				tempCart.setOrdrrId(cart.getOrdrrId());
				//자녀정보
				cartMapper.insertCart(tempCart);

				if(tempCart.getCartItemList() != null && tempCart.getCartItemList().size() > 0) {
					for(CartItem item : tempCart.getCartItemList()) {
						item.setCartItemNo(cartItemIdGnrService.getNextBigDecimalId());
						item.setCartNo(tempCart.getCartNo());
						item.setGitemCo(item.getGitemCo());
						cartMapper.insertCartItem(item);
					}
				}
			}
		}

	}
	
	//장바구니 체험구독 여부
	 @Override
	public int selectCartExistCnt(CartVO cart) throws Exception {
		return cartMapper.selectCartExistCnt(cart);
	}
}
