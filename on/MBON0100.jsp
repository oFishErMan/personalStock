<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="vueapp">
    <template>
	    <div id="container">
	        <div id="content" class="sub_content">
	            <section class="piece_wrap">
	                <div class="piece_wrap__list">
	                    <ul>
	                        <li class="item active" :id='"cateALL"' @click="setNoteCate('ALL');"><a href="#"><span class="text_img">👏🏻</span><span class="text">추천</span></a></li>
	                        <li class="item" :id='"cate"+ item.SUB_CAT_CD' @click="setNoteCate(item.SUB_CAT_CD)" v-for="(item, index) in category"><a href="#"><span class="text_img">{{cateIcon[index]}}</span><span class="text">{{item.SUB_CAT_NM.split(",")[1]}}</span></a></li>
	                    </ul>
	                </div>
	                <div class="search_option">
	                    <button type="button" class="btn_option" @click="tooltipClose();slideType('slide_layer01');"><span class="blind">검색옵션</span></button>
	                    <input type="text" v-model="noteSearch" id="" :placeholder="noteSearchLabel + '을 입력해 보세요.'" @keyup.enter="setNoteSearch()">
	                    <div class="tooltip">아이콘을 눌러 검색 옵션값을 선택할 수 있어요! <button type="button" id="tooltip_close" class="tooltip_close"><span class="blind">툴팁닫기</span></button></div>
	                </div>
	
	                <div class="piece_none" v-if="note.length === 0">
	                    <p>인기피스가 없어요.</p>
	                </div>
	                <div class="piece_list" v-else>
	                    <div class="piece_item">
	                        <div class="justifyWrap">
	                            <span class="count">총  <em>{{pageInfo.totalCount}}</em>건</span>
	                            <button type="button" class="btn_sort layer_open" @click="slideType('slide_layer02')">{{ noteSortLabel }}</button>
	                        </div>
	                    </div>
	
	                    <div class="piece_item" v-for="item in note">
	                        <div class="piece_item__image" @click="cf_movePage('/mb/nd/MBND0100?nteId='+ item.NTE_ID)">
	                            <img :src="cf_isEmpty(item.NTE_IMG) ? '/static_resources/images/no_img.svg' : '/common/fileDn?p=' + item.NTE_IMG"
	                            	alt="핫피스 대표이미지"
									:style="cf_isEmpty(item.NTE_IMG) ? hotNoImgStyles : {}">
	                            <span class="category">{{item.SUB_CAT_NM.split(',')[1]}}</span>
	                            <button type="button" class="like"><strong>{{item.LIKE_CNT}}명</strong>이 하트했어요.</button>
	                        </div>
	                        <div class="piece_item__content">
	                            <div class="comment_area">
	                                <div class="comment_box">
	                                    <span v-if="!cf_isEmpty(item.PF_IMG)" class="comment_thumb"><img :src="'/common/fileDn?p=' + item.PF_IMG" alt="프로필 사진"></span>
	                                    <span v-else-if="!cf_isEmpty(item.DEF_IMG)"  class="comment_thumb"><img :src="'/static_resources/images/character' + item.DEF_IMG + '.svg'" alt="프로필 사진"></span>
	                                    <div class="comment_nick">
	                                        <strong>{{item.NTE_NM}}</strong>
	                                        <span class="text">{{item.NICKNM}} <i>구독자 {{item.SUB_CNT}}명</i></span>
	                                    </div>
	                                </div>
	                                <div class="comment_text">{{item.NTE_DESC}}</div>
	                            </div>
	                        </div>
	                    </div>
	                </div>
	            </section>
	        </div>
    <!-- 검색옵션 레이어팝업 -->
	<div class="layer_popup_wrap slide_layer" id="slide_layer01">
	    <div class="layer_popup_header">
	        <h2 class="title">검색옵션</h2>
	        <button type="button" class="layer_popup_close"><span class="blind">닫기</span></button>
	    </div>
	    <div class="layer_popup_body">
	        <ul class="list_check">
	            <li class="on" @click="setNoteSearchLabel($event)"><button type="button">피스제목</button></li>
	            <li @click="setNoteSearchLabel($event)"><button type="button">닉네임</button></li>
	        </ul>
	        </div>
	    </div>
	</div>
	<!-- //검색옵션 레이어팝업 -->
	
	<!-- 정렬기준 레이어팝업 -->
	<div class="layer_popup_wrap slide_layer" id="slide_layer02">
	    <div class="layer_popup_header">
	        <h2 class="title">정렬기준 선택</h2>
	        <button type="button" class="layer_popup_close"><span class="blind">닫기</span></button>
	    </div>
	    <div class="layer_popup_body">
	        <ul class="list_check">
	        	<li class="on" @click="setNoteSort('RCMD', $event)"><button type="button">추천순</button></li>
	            <li @click="setNoteSort('LIKE', $event)"><button type="button">좋아요순</button></li>
	            <li @click="setNoteSort('VIEW', $event)"><button type="button">조회순</button></li>
	            <li @click="setNoteSort('SUB', $event)"><button type="button" >구독자순</button></li>
	            <li @click="setNoteSort('CMT', $event)"><button type="button" >댓글순</button></li>
	            <li @click="setNoteSort('NAME', $event)"><button type="button" >피스제목순</button></li>
	            <li @click="setNoteSort('NICK', $event)"><button type="button" >닉네임순</button></li>
	        </ul>
	    </div>
	</div>
	    </div>
    </template>
    </div>
</div>
<script>
var vueapp = new Vue({
    el : "#vueapp",
    beforeMount() {
    	this.initGetNote();
    },
    mounted : function(){
        $(document).ready(function(){
        	$('.piece_wrap__list li').on('click',function(){
                $(this).addClass('active').siblings().removeClass('active');
            });
        	
            $('.list_check li').on('click',function(){
                $(this).addClass('on').siblings().removeClass('on');
                $('.layer_popup_close').click();
            });
            
            $('#header .btn_total_menu').on('click',function(){
                vueapp.openMenu = true;
            });
            $('.total_menu__header .btn_total_menu').on('click',function(){
            	vueapp.openMenu = false;
            });
        });
    	this.tabInfo();
    	this.nextGetNote();
    },
    updated : function() {
    	//카테고리 값 있을 시 active 클래스 추가
         $('#cate'+this.noteCate).siblings().removeClass('active');
    	 $('#cate'+this.noteCate).addClass('active');
    },
    data : {
    	category: ${noteCateList}, // 공개노트 카테고리
    	note: [], // 노트 목록
    	pageInfo : [], // 페이징 정보
    	noteSort : 'RCMD', // 노트 정렬 정보
    	cateIcon : [],
    	noteSortLabel : '추천순', // 화면 정렬버튼 표시
    	noteSearch : '', // 검색어
    	page : 1, //최초 페이지
    	noteSearchLabel : '피스제목', // 검색 기준 표시
    	noteCate : '${cate}', // 카테고리
    	hotNoImgStyles : { position: 'absolute', height: '50%', backgroundColor: '#fff', padding: '65px 0px', objectFit: 'contain' },
    	chkAjax : true,
    	openMenu : false,
    	
    },
    methods : {
    	initGetNote : function() { //최초 시작 시 노트 불러오기
    		if(this.noteCate == '') {
    			this.getNote('ALL');           	
            } else {
            	this.getNote(this.noteCate);	
            }
    	},
    	nextGetNote : function() { //스크롤 해서 페이지의 바닥면에 닿을 시 다음 페이지 출력
    		window.onscroll = () => {
    	        if (Math.round(window.scrollY + window.innerHeight) === document.body.scrollHeight
    	        	&& this.pageInfo.hasNextPage) {
    	        	if(!this.openMenu) {
			   	     	setTimeout(() => this.getNote(this.noteCate), 100);
    	        	}
    	        }
    	    }
    	},
        
        tabInfo : function() {
        	for (var i = 0; i < this.category.length; i++) {
        		var split = this.category[i].SUB_CAT_NM.split(',')
        		this.cateIcon.push(split[0]);	
			}
        },
    	getNote : function(catCd) { // 노트 불러오기
    		var pageConf = cf_getPageConf("getNote");
    		pageConf.pageNo = this.page;
    		pageConf.func = this.getNote; //getNote를 공통 페이징 함수에 등록
    		pageConf.limit = 5; //5개씩 페이징
    		
            var options = {
                params: {
                    catCd: catCd,
                    search : this.noteSearch,
                    sort : this.noteSort,
                    noteSearchLabel : this.noteSearchLabel,
                },
                pageConfKey : "getNote",
            }
            if(this.chkAjax) {
            	this.chkAjax = false;
            	
            	cf_ajax("/mb/on/MBON0102", options).then(this.getNoteCB);
            }
    		
        },
        
        getNoteCB : function(data) {
            if( this.page <= data.pageInfo.totalPages) {
            	this.pageInfo = data.pageInfo;
                for(let i = 0; i < data.list.length; i++) { //기존 노트에 추가(push)
                	this.note.push(data.list[i]);
                }
                this.page += 1 ;
            } else {
            	this.pageInfo = data.pageInfo;
            }
            this.chkAjax = true;
        },
        
        setNoteCate : function(cate) {
        	this.note = [];
    		this.page = 1;
    		this.noteCate = cate;
    		this.noteSearch = '';
			this.getNote(cate);
    	},
    	setNoteSort : function(sort, event) {
    		this.note = [];
    		this.page = 1;
    		this.noteSort = sort;
    		this.noteSortLabel = event.target.innerText;
			this.getNote(this.noteCate);
    	},        
        setNoteSearch : function() {
    		this.note = [];
    		this.page = 1;
			this.getNote(this.noteCate);
    	},
    	setNoteSearchLabel : function(event) {
    		this.noteSearchLabel = event.target.innerText;
    	},
    	tooltipClose : function() {
    		document.getElementById('tooltip_close').click();
    	},
    	slideType : function(layer) {
            const _this = $(this);
            const layerPopup = $("#" + layer);
            const layerObjClose = layerPopup.find(".layer_popup_close");
            const layerObj = layerPopup.find("button, input:not([type='hidden']), select, iframe, textarea, [href], [tabindex]:not([tabindex='-1'])");
            const layerObjFirst = layerObj && layerObj.first();
            const layerObjLast = layerObj && layerObj.last();
            let tabDisable;

            // Slide Popup 시 내용이 길어서 Scroll 생성 및 Title Line 생성
            const slideheaderH = layerPopup.find('.layer_popup_header').outerHeight();
            const slideH = layerPopup.outerHeight() - slideheaderH;
            layerPopup.css({"transform":"translate(0, 0)"});
            $('body').css({overflow : 'hidden' });
            let layerClose = function () {
                const layerH = layerPopup.height();
                $('.dim').fadeOut().queue(function(){
                    $('.dim').remove();
                });
                layerPopup.animate({
                    bottom: -layerH
                });
                if (tabDisable === true) layerPopup.attr("tabindex", "-1");
                _this.focus();
                $(document).off("keydown.lp_keydown");
                $('body').css({overflow : 'auto' });
            }

            layerObjClose.on("click", layerClose); // 닫기 버튼 클릭 시 레이어 닫기

            $('body').append('<div class="dim"></div>');
            layerPopup.animate({
                bottom: 0
            },200);

            $('.dim').on("click",  layerClose);
			
            $(document).on("keydown.lp_keydown", function(event) {
                // Esc키 : 레이어 닫기
                const keyType = event.keyCode || event.which;

                if (keyType === 27) {
                	layerClose;
                }
            });
        },
    },
});
</script>