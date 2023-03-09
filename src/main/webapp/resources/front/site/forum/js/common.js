/*
	Author	: hyojeong yang
	Date	: 2022-10-18
	Project	: DX 교육데이터 협회
*/

var ie = /MSIE/.test(navigator.userAgent);
ieVer = ie ? parseInt(navigator.userAgent.split('MSIE')[1].split(';')[0]) : false;

if (typeof Object.assign != 'function') {
    // Must be writable: true, enumerable: false, configurable: true
    Object.defineProperty(Object, "assign", {
        value: function assign(target, varArgs) { // .length of function is 2
            'use strict';
            if (target == null) { // TypeError if undefined or null
                throw new TypeError('Cannot convert undefined or null to object');
            }

            var to = Object(target);

            for (var index = 1; index < arguments.length; index++) {
                var nextSource = arguments[index];

                if (nextSource != null) { // Skip over if undefined or null
                    for (var nextKey in nextSource) {
                        // Avoid bugs when hasOwnProperty is shadowed
                        if (Object.prototype.hasOwnProperty.call(nextSource, nextKey)) {
                            to[nextKey] = nextSource[nextKey];
                        }
                    }
                }
            }
            return to;
        },
        writable: true,
        configurable: true
    });
}

// ------------------------  공통함수 ------------------------
var exTarget;
var a11yFocus = function () { // 접근성 포커싱 관련 공통 함수. 함수 선언 시 exTarget 전역변수로 넣어줘야함.
    function openFocus(_this, _focus, tabIndex) {
        exTarget = $(_this);

        setTimeout(function () {
            if (tabIndex == true) {
                _focus.attr('tabindex', '1').focus();
            } else {
                _focus.focus();
            }
        }, 0)
    }
    function closeFocus(tabIndex) {
        setTimeout(function () {
            if (tabIndex == true) {
                $(exTarget).attr('tabindex', '-1').focus();
            } else {
                $(exTarget).focus();
            }
        }, 0)
    }
    return {
        openFocus: openFocus,
        closeFocus: closeFocus,
    }
}

/**
 * @param opt {
 * obj : 토글 클래스가 붙을 오브젝트,
 * className : 토글시 클래스명,
 * hasClass : 요소가 클래스를 가지고 있을 때 함수를 실행한다,
 * noneClass : 요소가 클래스를 가지고 있지 않을 때 함수를 실행한다,
 * }
 */
var toggleCommonFunc = function (opt) {
    opt.obj = opt.obj;

    $(opt.obj).toggleClass(opt.className);

    if ($(opt.obj).hasClass(opt.className)) {
        opt.hasClass()

    } else {
        opt.noneClass();
    }
}

/**
 *
 * @param opt {
 * pc : function
 * mo : function
 * ta : fucntion
 * }
 */
var ssmFunc = function (opt) {
    var ssmPc = (opt.hasOwnProperty('pc') && opt.pc) ? true : false;
    var ssmTa = (opt.hasOwnProperty('ta') && opt.ta) ? true : false;
    var ssmMo = (opt.hasOwnProperty('mo') && opt.mo) ? true : false;

    if (ssmPc) {
        ssm.addState({
            id: 'pc',
            query: '(min-width: 1280px)',
            onEnter: function () {
                opt.pc();
            },
        });
    }
    if (ssmTa) {
        ssm.addState({
            id: 'ta',
            query: '(min-width: 768px) and (max-width: 1279px)',
            onEnter: function () {
                opt.ta();
            },
        });
    }
    if (ssmMo) {
        ssm.addState({
            id: 'mo',
            query: '(max-width: 767px)',
            onEnter: function () {
                opt.mo();
            },
        });
    }
};

if (jQuery) (function ($) {
    //common
    //$.extend($.fn, {
    //    Func: function () {
    //        var init = function (obj) {

    //        };
    //        $(this).each(function () {
    //            init(this);
    //        });
    //        return $(this);
    //    }
    //});

    //component
    //accordion
    $.extend($.fn, {
        accordionFunc: function () {
            var init = function (obj) {
                var $btn = $(obj).find('li').find('.btn-accordion-toggle');
                $(document).on('click', $btn, function (e) {
                    var $target = $(e.target);
                    if ($target.is($btn)) {
                        $target.closest('li').siblings('li').removeClass('is-active');
                        toggleCommonFunc({
                            obj: $target.closest('li'),
                            className: 'is-active',
                            hasClass: function (obj) {
                                //$(obj).removeClass('is-active');
                                TweenMax.fromTo('.accordion-txt-area', .5, { opacity: 0 }, { opacity: 1 });
                                $btn.html('열기');
                                $target.html('닫기');
                            },
                            noneClass: function (obj) {
                                TweenMax.fromTo('.accordion-txt-area', .5, { opacity: 1 }, { opacity: 0 });
                                $btn.html('열기');
                            }
                        });
                    }
                });
            };
            init(this);
            return $(this);
        }
    });

    //btnarrToggle
    $.extend($.fn, {
        btnarrToggleFunc: function () {
            var init = function (obj) {
                $(obj).on('click', function () {
                    $('.btn-arr-toggle').toggleClass('is-up');
                });
            };
            $(this).each(function () {
                init(this);
            });
            return $(this);
        }
    });

    //tabs-noraml
    $.extend($.fn, {
        tabsNormalFunc: function () {
            var init = function (obj) {
                var $currentTab = $(obj).find("[class^='tabs-nav']").find('a.is-active').attr('href');
                $($currentTab).show();

                $(obj).find("[class^='tabs-nav']").find('a').on('click', function () {
                    //var $li = $(this).parent('li');
                    if ($(this).hasClass("is-active") == false) {
                        $(obj).find("[class^='tabs-nav']").find('a').removeClass("is-active");
                        $(this).addClass("is-active");
                    }

                    $(obj).find('.tabs-cont').hide();
                    var $activeTab = $(this).attr('href');
                    $($activeTab).show();

                    return false;
                });
            };
            $(this).each(function () {
                init(this);
            });
            return $(this);
        }
    });


     //common
    //header
    $.extend($.fn, {
        headerFunc: function () {
            var init = function (obj) {
                var headerH = $('.site-header').height();
                var tl = new TimelineMax();
               
                //tl.fromTo($('.site-header.is-sticky'), .3, { yPercent: -100, opacity: 0 }, { yPercent: 0, opacity: 1 });
                var controller = new ScrollMagic.Controller();
                var scene = new ScrollMagic.Scene({
                    offset: 1
                }).setClassToggle('.site-header', 'is-sticky').addTo(controller);

                var scene = new ScrollMagic.Scene({
                    offset: 100
                }).setClassToggle('.btn-top', 'is-sticky').addTo(controller);
            };
            init(this);
            return $(this);
        }
    });


    //gnbFunc
	$.extend($.fn, {
		gnbFunc: function () {
			var init = function (obj) {
				var $gnb = $(obj),
					$dep1 = $gnb.find('>ul>li'),
					$frist = $gnb.find('>ul>li:first-child>a'),
					$last = $gnb.find('>ul>li:last-child>ul>li:last-child a');

				//mouseenter, 
				$(document).on('mouseenter', '.menu>ul>li', function (e) {
					$gnb.find('>ul>li').removeClass('is-active');
					// TweenMax.fromTo($(this).find('ul'), .3, { opacity: 0, height: 0 }, { opacity: 1, height: "auto" });
					$(this).addClass('is-active');
				});

				$(document).on('mouseleave', '.menu>ul>li', function () {
					$(this).removeClass('is-active');
				});

				//$dep1.on('mouseenter', function () {
				//	$gnb.find('>ul>li').removeClass('is-active');
				//	TweenMax.fromTo($(this).find('ul'), .3, { opacity: 0, height: 0 }, { opacity: 1, height: "auto" });
				//	$(this).addClass('is-active');
				//});

				//mouseleave
				//$dep1.on('mouseleave', function () {
				//	$(this).removeClass('is-active');
				//});

				//focusin
				//$dep1.on('focusin', function () {
				//	$gnb.find('>ul>li').removeClass('is-active');
				//	$(this).addClass('is-active');
				//});

				////첫링크 포커스 아웃
				//$frist.keyup(function (e) {
				//	if (e.shiftKey && e.keyCode == 9) {
				//		$gnb.find('>ul>li').removeClass('is-active');
				//	}
				//});

				////마지막링크 포커스 아웃
				//$last.keyup(function (e) {
				//	if (e.keyCode == '9') {
				//		$gnb.find('>ul>li').removeClass('is-active');
				//	}
				//});
			};
			init(this);
			return $(this);
		}
	});

    //btnarrToggle
    $.extend($.fn, {
        menuToggleFunc: function () {
            var init = function (obj) {
                $(document).on('click', '.btn-menu-toggle', function () {
                    $('.menu-area').toggleClass('is-active');
                });
            };
            $(this).each(function () {
                init(this);
            });
            return $(this);
        }
    });

	//fsiteSwiper
	$.extend($.fn, {
		fsiteSwiper: function () {
			var init = function (obj) {
				const swiper = new Swiper('.fsite-swiper', {
					slideToClickedSlide: false,
					slidesPerView: 'auto',
                    spaceBetween: 10,
					initialSlide: 0,
					watchSlidesProgress: true,
					spaceBetween: 15,
					loop: true,
					freeMode: false,
					// observer: true,
					// observeParents: true,
                    autoplay:true,
					//navigation: {
					//	prevEl: '.swiper-button-prev',
					//	nextEl: '.swiper-button-next'
					//},
					breakpoints: {
						// mo
						0: {
							// slidesPerView: 2.5,
							spaceBetween: 28
						},
						// tablet
						767: {
							// slidesPerView: 3.5,
							spaceBetween: 40
						},
						// pc
						1279: {
							// slidesPerView: 'auto',
							// loop: false,
							spaceBetween: 60,
						}
					}
				});
			}
			$(this).each(function () {
				init(this);
			});
			return $(this);
		}
	});

})(jQuery);

$(window).on('load', function () {
    //component
    //accordionFunc 
    $('.accordion').accordionFunc();
    $('.btn-arr-toggle').btnarrToggleFunc();
    $('.tabs-normal').tabsNormalFunc();

	$('.fsite-swiper').fsiteSwiper();
    $('.site-header').headerFunc();
    $('.menu-area').menuToggleFunc();
    $('.menu').gnbFunc();

    var controller = new ScrollMagic.Controller();
    $(".section, .mn-section, .sub-top").each(function (i) {
		new ScrollMagic.Scene({
			triggerElement: this,
			triggerHook: 0.8
		}).setClassToggle(this, 'is-active').addTo(controller);
	});

});


