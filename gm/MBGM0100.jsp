<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="vueapp">
    <template>
	    <div id="container">
	        <div id="content" class="sub_content">
	            <div class="piece_admin">
	                <div class="tab_wrap">
	                    <ul id="tab">
	                        <li><a href="#none" id="tabGonggi" @click="changeTab('g')">포켓</a></li>
	                        <li><a href="#none" id="tabPiece" @click="changeTab('p')">피스</a></li>
	                    </ul>
	                    <div id="tab__con">
	                        <div class="list_wrap">
	                            <div id="test1">
	                                <!-- 포켓 관리 -->
	                                <div class="list_none" v-if="gonggi.length === 0">
					                    <p>포켓이 없습니다.</p>
					                </div>
	                                <div class="list_wrap__item" :data-id="item.GRP_ID" v-for="(item, index) in gonggi" :id="index+'gonggi'">
	                                    <div class="item_cotent" :id="'item_cotent'+index">
	                                        <div class="block">
	                                            <div class="name_area">
	                                                <a href="#" @click="openLayerPopup('slide_layer01', item.GRP_ID, item.GRP_NM, item.GRP_CLR, item.GRP_FRM, index); removeLeft();">
	                                                    <span class="icon"><img :src="'/static_resources/images/'+item.GRP_CLR+'_gonggi'+item.GRP_FRM+'.svg'" alt=""></span>
	                                                    <span class="name">{{item.GRP_NM}} <em>{{item.PIECE_CNT}}</em></span>
	                                                </a>
	                                            </div>
	                                            <button type="button" class="handle" v-if="item.ORD_NO != 0"><span class="blind">이동</span></button>
	                                        </div>
	                                        <button type="button" class="btn_del" @click="deleteGonggi(item, index)" v-if="index > 0">삭제</button>
	                                    </div>
	                                </div>
	                            </div>
	                            <ul class="tip_list" v-if="gonggi.length !== 0">
	                                <li>포켓 이름을 터치하면 이름을 수정할 수 있어요.</li>
	                                <li>아이콘(<i class="icon"></i>)을 눌러 순서를 바꿀 수 있어요.</li>
	                                <li>왼쪽으로 밀면 포켓을 삭제할 수 있어요.</li>
	                            </ul>
	                            <div class="btn_wrap fixed">
                                	<button v-if="gonggi.length !== 0" type="button" class="btn btn--big" :disabled="gonggiBtn" @click="modifyGonggiOrdno()"><span>순서 저장</span></button>
                            	</div>
	                        </div>
	                        <div>
	                            <div class="item_area padTop20 padBottom10" id="itemH">
	                                <div class="select_wrap" @click="openSortPieceList(event)">
	                                    <div class="selected_value">포켓을 선택해 주세요.</div>
	                                    <div class="option_wrap">
	                                        <ul class="option_list">
	                                            <li class="option" id="gonggiAll" @click="setSortPiece(event, 'ALL')">전체</li>
	                                            <li class="option" v-for="item in gonggi" @click="setSortPiece(event, item.GRP_ID);removeLeft();">{{item.GRP_NM}}</li>
	                                        </ul>
	                                    </div>
	                                </div>
	                            </div>
	                            <div class="list_wrap">
	                                <!-- 피스 관리 -->
	                                <div class="list_none" v-if="piece.length === 0">
					                    <p>피스가 없어요.</p>
					                </div>
	                                <div class="list_wrap__item" v-for="(item, index) in piece" :id="index+'piece'">
	                                    <div class="item_cotent" :id="'pitem_cotent'+index">
	                                    	<div class="block">
	                                            <div class="name_area">
	                                                <a href="#" @click="openModifyLayer(item.NTECR_ID, item.NTE_ID, index, item.GRP_ID);removeLeft(); ">
	                                                    <span class="thumb">
	                                                    	<img v-if="item.ORDER_NUM < 4" :src="'/static_resources/images/no_img.svg'" :style="pieceNoImgStyles">
	                                                    	<img v-else :src="cf_isEmpty(item.NTE_IMG) ? '/static_resources/images/no_img.svg' : '/common/fileDn?p=' + item.NTE_IMG" :style="cf_isEmpty(item.NTE_IMG) ? pieceNoImgStyles : {}" :style="pieceNoImgStyles">
                                                    	</span>
	                                                    <span class="name" v-if="item.ORDER_NUM === 0">삭제된 피스입니다.<br>({{item.NTE_NM.substr(0,2)}}***)</span>
	                                                    <span class="name" v-else-if="item.ORDER_NUM === 1">차단된 피스입니다.<br>({{item.NTE_NM.substr(0,2)}}***)</span>
	                                                    <span class="name" v-else-if="item.ORDER_NUM === 2">블라인드 처리된 피스입니다.<br>({{item.NTE_NM.substr(0,2)}}***)</span>
	                                                    <span class="name" v-else-if="item.ORDER_NUM === 3">비공개 피스입니다.<br>({{item.NTE_NM.substr(0,2)}}***)</span>
	                                                    <span class="name" v-else>{{item.NTE_NM}}</span>
	                                                </a>
	                                            </div>
	                                            <div class="right_area">
	                                            	<span class="list_label subscribing" v-if="item.NTECR_ID !== mbrId && item.MBR_PERM == 'READ'">구독중</span>
	                                            	<span class="list_label joining" v-if="item.NTECR_ID !== mbrId && item.MBR_PERM == 'WRITE'">참여중</span>
	                                            	<button type="button" v-if="item.ORDER_NUM < 4" :id="'favorites'+index" class="favorites none">
			                                            <span class="blind">즐겨찾기</span>
		                                            </button>
	                                            	<button type="button" v-else :id="'favorites'+index" :class=" item.FAV_YN == 'Y' ? 'favorites on' : 'favorites' " @click="setFavorites(event, index, item.MYNTE_ID)">
			                                            <span class="blind">즐겨찾기</span>
		                                            </button>
	                                            </div>
	                                        </div>
   	                                        <button v-if="item.NTECR_ID === mbrId" type="button" class="btn_del" @click="deletePiece(item, index)">삭제</button>
	                                        <button v-else-if="item.MBR_PERM == 'WRITE'" type="button" class="btn_del" @click="deletePiece(item, index)">참여중지</button>
	                                        <button v-else type="button" class="btn_del" @click="deletePiece(item, index)">구독취소</button>
	                                    </div>
                                    </div>
	                                <!-- //피스 관리 -->
	                            </div>
	                            <ul class="tip_list" v-if="piece.length !== 0">
	                                <li>내 피스의 이름을 터치하면 수정할 수 있어요.</li>
	                                <li>구독한 피스의 이름을 터치하면 포켓 위치를 수정할 수 있어요.</li>
	                                <li>아이콘(<i class="icon star"></i>)을 눌러 즐겨찾기에 저장할 수 있어요.</li>
	                                <li>왼쪽으로 밀면 피스를 삭제할 수 있어요.</li>
	                            </ul>
	                        </div>
	                    </div>
	                </div>
	            </div>
	        </div>
	    </div>
    <!-- 포켓 추가 레이어 팝업 -->
	<div class="layer_popup_wrap slide_layer" id="slide_layer01">
	    <div class="layer_popup_header">
	        <h2 class="title">포켓 수정</h2>
	        <button type="button" class="layer_popup_close" id="closeBtn"><span class="blind">닫기</span></button>
	    </div>
	    <div class="layer_popup_body">
	        <!-- 주황색 포켓 -->
	        <div class="color_swiper on">
	            <div class="swiper">
	                <div class="swiper-wrapper">
	                    <div class="swiper-slide"><img :src="'/static_resources/images/' + changeGonggiColor + '_gonggi01.svg'" alt=""></div>
	                    <div class="swiper-slide"><img :src="'/static_resources/images/' + changeGonggiColor + '_gonggi02.svg'" alt=""></div>
	                    <div class="swiper-slide"><img :src="'/static_resources/images/' + changeGonggiColor + '_gonggi03.svg'" alt=""></div>
	                    <div class="swiper-slide"><img :src="'/static_resources/images/' + changeGonggiColor + '_gonggi04.svg'" alt=""></div>
	                    <div class="swiper-slide"><img :src="'/static_resources/images/' + changeGonggiColor + '_gonggi05.svg'" alt=""></div>
	                </div>
	                <div class="swiper-button-next"></div>
	                <div class="swiper-button-prev"></div>
	            </div>
	        </div>
	        <form action="">
		            <div class="gonggi_color_select">
		                <div class="radio_item" :class="{ 'on' : changeGonggiColor === 'orange' }">
		                	<input type="radio" name="option" id="orange" value="orange" v-model="changeGonggiColor">
		                	<label for="orange"><span class="blind">주황색</span></label>
		                </div>
		                <div class="radio_item" :class="{ 'on' : changeGonggiColor === 'blue' }">
		                	<input type="radio" name="option" id="blue" value="blue" v-model="changeGonggiColor">
		                	<label for="blue"><span class="blind">파란색</span></label>
		                </div>
		                <div class="radio_item" :class="{ 'on' : changeGonggiColor === 'yellow' }">
		                	<input type="radio" name="option" id="yellow" value="yellow" v-model="changeGonggiColor">
		                	<label for="yellow"><span class="blind">노란색</span></label>
		                </div>
		                <div class="radio_item" :class="{ 'on' : changeGonggiColor === 'pink' }">
		                	<input type="radio" name="option" id="pink" value="pink" v-model="changeGonggiColor">
		                	<label for="pink"><span class="blind">분홍색</span></label>
		                </div>
		                <div class="radio_item" :class="{ 'on' : changeGonggiColor === 'green' }">
		                	<input type="radio" name="option" id="green" value="green" v-model="changeGonggiColor">
		                	<label for="green"><span class="blind">녹색</span></label>
		                </div>
		            </div>
		        </form>
	        <div class="input_wrap gonggi_name">
	            <div class="input_inner">
	                <input type="text" name="" id="" v-model="changeGonggiName" maxlength="5" placeholder="포켓 이름을 입력해 주세요.">
	            </div>
	            <div class="font_size">
	                <span class="current">{{changeGonggiName.length}}</span>/<span class="total">5</span>
	            </div>
	        </div>
	    </div>
	    <div class="layer_popup_button">
	        <button type="button" class="btn" @click="modifyGonggiDetail" :disabled="gonggiLayerBtn"><span>확인</span></button>
	    </div>
	</div>
<!-- //포켓 추가 레이어 팝업 -->
<!-- 포켓 위치 선택 -->
<div class="layer_popup_wrap slide_layer" id="slide_layer00_2">
    <div class="layer_popup_header">
        <h2 class="title">포켓 위치 선택</h2>
        <button type="button" class="layer_popup_close" id="closeMoveGonggi"><span class="blind">닫기</span></button>
    </div>
    <div class="layer_popup_body">
        <div class="radio_wrap">
            <div class="radio" v-for='(item, index) in gonggi'><input type="radio" name="radio" :id="'radion_position0'+index"><label :for="'radion_position0'+index" @click="setMoveGonggi(item.GRP_ID)">{{item.GRP_NM}}</label></div>
        </div>
    </div>
    <div class="layer_popup_button">
        <button type="button" class="btn" :disabled="moveGonggiBtn" @click="moveGonggi()"><span>확인</span></button>
    </div>
</div>
<!-- //포켓 위치 선택 -->
</template>
</div>
</div>
<script src="/static_resources/lib/sortable/1.15.0/sortable.min.js"></script>
<script>
var vueapp = new Vue({
    el : "#vueapp",
    watch : {
    	changeGonggiName  : function(value){
    		//this.gonggiNameLength = value.length;
    		this.gonggiLayerBtn = false;
    	},
    	
    	changeGonggiColor : function(value) {
    		this.gonggiLayerBtn = false;
    	}
    
    },
    mounted : function() {
    	let vh = window.innerHeight * 0.01;
	  	document.documentElement.style.setProperty('--vh', vh + `px`);
    	
    	common.tabType("#tab",0);
    	
    	this.getDrawer();
    	
    	// 포켓,피스관리 이동하기 스크립트
    	this.sortableGonggi = new Sortable(test1, {
            handle: '.handle', // handle's class
            animation: 150,
            sort : true,
            onEnd : function(evt) {
            	for (var i = 0; i < vueapp.gonggi.length; i++) {
            		for (var j = 0; j < vueapp.sortableGonggi.toArray().length; j++) {
            			if(vueapp.gonggi[i].GRP_ID === vueapp.sortableGonggi.toArray()[j] ) {
                			vueapp.gonggi[i].ORD_NO = j;//+1;  // index 를 1부터 시작하게 하는 부분 주석처리. 0번째 기본 폴더가 있으니까
                		}	
					}
				} 

            	vueapp.gonggiBtn = false;
            },
            onMove: function(event, originalEvent) {
            	// 타겟이 첫번째 요소(기본포켓, 수정삭제되지 않음)이면 false 를 리턴하여 순서가 바뀌지 않게..
            	if ($("#" + originalEvent.target.id).index() == 0)
            		return false;
            },
        });
    	
    	// 포켓 수정 Swiper
	    this.swiperGonggi = new Swiper(".color_swiper .swiper", {
	        navigation: {
	            nextEl: ".swiper-button-next",
	            prevEl: ".swiper-button-prev",
	        },
	        observer: true,
	        on: {
        		activeIndexChange: function(swiper) {
	        		vueapp.changeGonggiForm = '0' + (swiper.activeIndex + 1);
	        		vueapp.gonggiLayerBtn = false;
	        	},
	        },
	    });
	    
    },
    updated : function() {
        document.querySelector('.sub_content').style.overflow = "hidden";
    },
    data : {
    	mbrId : "${MBR_ID}",
        gonggi : [], // 포켓 리스트
        //piecesCountList : [], // 서랍내 피스 갯수
        piece : [], // 피스 리스트
        //deletePieceOwn : '',
        //gonggiNameLength : 0, //
        changeGonggiId : "", // 팝업시 수정할 포켓 Id
        changeGonggiName : "", // 팝업시 수정할 포켓 제목
        //changeGonggiOrderNo : "",// 팝업시 수정할 포켓 정렬번호
        changeGonggiColor : "orange", // 팝업시 수정할 포켓 색깔
        changeGonggiForm : "",// 팝업시 수정할 포켓 모양
        changeGonggiIndex : "",// 팝업시 수정할 포켓 순서
        changePieceIndex : "", // 팝업시 수정할 피스 
        moveGonggiId : "", // 팝업시 수정할 피스의 포켓 위치 
        deleteGrpId: "", // 삭제 서랍 ID
        sortPiece : "ALL",
        pieceNoImgStyles : { position: 'absolute',
	        left: '50%',
	        top: '50%',
	        width: '24px',
	        height: '24px',
	        margin: '-12px 0 0 -12px',
	        'object-fit': 'cover' },
        isSwiped : false,
        gonggiLayerBtn : true,
        gonggiBtn : true,
        pieceBtn : true,
        moveGonggiBtn : true,
        swiperGonggi : {},
        sortableGonggi : {},
        //initSortable : [],
        currentScroll : 0,
    },
    methods : {
    	// 팝업 시 스크롱 위치 저장
    	getHeight : function() {
    		var height = document.getElementById('header').clientHeight
    					+document.getElementById('tab').clientHeight
    					+document.getElementById('itemH').clientHeight;
    		var body = document.querySelector('body').offsetHeight;
    		for (var i = 1; i < this.piece.length+1; i++) {
				height += (84*i)
				if(body - height < 134) {
					body = 134;
					$('.tip_list').css({
		    			"height": "134px" 
		    		})
				} else {
					$('.tip_list').css({
		    			"height": "calc("+body+"px - "+height+"px)" 
		    		})
				}
			}
    		if(this.piece.length === 0) {
    			$('.tip_list').css({
	    			"height": "calc("+body+"px - "+height+"px)" 
	    		})
    		}
    	},
    	
    	//포켓 목록 불러오기
        getDrawer : function() {
        	this.gonggi = [];
            var options = {
                params : {
                    mbrId : this.mbrId,
                },
            }

            cf_ajax("/mb/gm/MBGM0101", options).then(this.getDrawerCB);
        },
        getDrawerCB : function(data) {
        	/*
        	for (var i = 0; i < data.length; i++) {
				data[i].delYn = "n";
			}
        	*/
        	this.gonggi = data;
        	//for (var i = 0; i < this.gonggi.length; i++) {
        		//this.initSortable.push(this.gonggi[i].GRP_ID);
    		//}
        	
        	this.$nextTick(function() { 
				this.initPage();
		        }); 
        },
        
        //포켓의 피스 갯수 불러오기
        /*
        getPiecesCount : function() {
        	this.piecesCountList = [];
        	var options = {
                    params : {
                    	mbrId : this.mbrId
                    },
                }

            cf_ajax("/mb/gm/MBGM0102", options).then(this.getPiecesCountCB);
      	},
            
		getPiecesCountCB : function(data) {
			console.log("getPiecesCountCB) data = ", data);
			/*
			for (var i = 0; i < data.length; i++) {
				if(data[i].count === null) {
					data[i].count = 0;
				}
			}
			* /
        	this.piecesCountList = data;
        },
        */
        
        //피스 목록 불러오기
        getPieceList : async function() {
        	this.piece = [];
        	var options = {
                    params : {
                    	mbrId : this.mbrId,
                    	sortPiece : this.sortPiece
                    },
                }

            await cf_ajax("/mb/gm/MBGM0104", options).then(this.getPieceListCB);
        },
        
		getPieceListCB : function(data) {
			for (var i = 0; i < data.length; i++) {
				data[i].delYn = "n";
			}
			this.piece = data;
			this.$nextTick(function() { 
				this.getHeight();
				this.initPage();
		        }); 
        },
        
		// 포켓 순서 저장
        modifyGonggiOrdno : function() {
        	const option = {
                    title: "포켓 순서 변경",
                    msg : "순서를 저장할까요?",
                    confirmCB : () => {
                    	var options = {
                            params : {
                            	mbrId : this.mbrId,
                            	gonggi : this.gonggi,
                            },
                        }
                        cf_ajax("/mb/gm/MBGM0103", options).then(this.modifyGonggiOrdnoCB);},
                    cancelCB : () => {return;},
                }
            mb_confirm(option);
        },
        
        modifyGonggiOrdnoCB : function(data) {
        	const option = {
                    title: "포켓 순서 변경",
                    msg : "저장이 완료되었어요.",
                    confirmCB : () => {location.reload()},
                }
            mb_alert(option);
        	this.gonggiBtn = true;
        },
        
        // 포켓 삭제
        deleteGonggi : function(item, index) {
        	if(Number(item.PIECE_CNT) !== 0) {
        		const options = {
                        title: "포켓 삭제",
                        msg : "포켓에 남아있는 피스가 있는경우\n삭제할 수 없어요.",
                        confirmCB : () => {
                        },
                    }
                mb_alert(options);
        		return;
        	}
        	const options = {
                    title: "포켓 삭제",
                    msg : "포켓을 삭제 할까요?\n삭제 하시는 경우\n데이터를 복구할 수 없어요.",
                    confirmTxt : "삭제",
                    confirmCB : () => {
                    	var options = {
                                params : {
                                	mbrId : this.mbrId,
                                	GRP_ID : item.GRP_ID,
                                },
                            };
                   		cf_ajax("/mb/gm/MBGM0109", options).then(this.deleteGonggiCB);
                   		this.gonggi.splice(index,1);
                   		//this.piecesCountList.splice(index,1);
                   		$('#item_cotent'+index).removeClass('left');
                    },
                    cancelCB : () => {},
                }
            mb_confirm(options);
        },
        deleteGonggiCB : function(data) {
        	mb_alert({
        		title : "포켓 삭제",
        		msg : "포켓이 삭제되었어요."
        	})
        },
        // 피스 삭제
        deletePiece : function(item, index/*nteid, index, ntecr, myid*/) {
        	var options = {};
        	var params = {mbrId : this.mbrId,
               			  MYNTE_ID : item.MYNTE_ID,
	                	  NTE_ID : item.NTE_ID,
	                	  NTECR_ID : item.NTECR_ID};

        	if (item.NTECR_ID == this.mbrId) {   // 내 노트인경우
        		options.title = "피스 삭제";
        		options.msg = "피스를 삭제할까요?\n삭제 하시는 경우\n데이터를 복구할 수 없어요.";
        		options.confirmTxt = "삭제";
        		
        		params.type = "MY";
        	} else if (item.MBR_PERM == 'WRITE') {
        		options.title = "참여 중지";
        		options.msg = "참여를 중지할까요?\n구독도 해제되요.";
        		options.confirmTxt = "참여중지";

        		params.type = "WRITE";
        	} else {   //if (item.MBR_PERM = 'READ')
        		options.title = "구독 해지";
        		options.msg = "구독을 해지할까요?";
        		options.confirmTxt = "구독해지";
        		
        		params.type = "READ";
        	}
        	
        	options.confirmCB = () => {
           		cf_ajax("/mb/gm/MBGM0105", {params : params}).then(this.deletePieceCB);
           		this.piece.splice(index,1);
           		$('#pitem_cotent'+index).removeClass('left');
            };
        	mb_confirm(options);
        },
        
        deletePieceCB : function(data) {
        	options = {};
        	
        	if (data.type == "MY") {R
        		options.title = "피스 삭제";
        		options.msg = "피스가 삭제되었어요.";
        	} else if (data.type == "WRITE") {
        		options.title = "참여 중지";
        		options.msg = "참여를 중지했어요.\n피스의 구독도 해제되었어요";
        	} else {
        		options.title = "구독 해지";
        		options.msg = "구독이 해지되었어요.";
        	}
        	
        	mb_alert(options);
        },
        
        // 포켓 상세 
        modifyGonggiDetail : function() {
        	if(Number(this.gonggiNameLength) === 0) {
        		const option = {
                        title: "포켓 수정",
                        msg : "포켓의 이름을 적어주세요.",
                    }
                mb_alert(option);
        		return;
        	}
        	
        	for (var i = 0; i < this.gonggi.length; i++) {
				if(this.gonggi[i].GRP_NM === this.changeGonggiName) {
					if(Number(this.changeGonggiIndex) !== i) {
						mb_alert({
							title : "포켓 수정",
							msg : "포켓명은 중복이 불가능해요."
						})
						return;
					}
				}
			}
        	
        	const option = {
                    title: "포켓 수정",
                    msg : "포켓을 수정할까요?",
                    confirmCB : () => {
                    	var options = {
                            params : {
                            	mbrId : this.mbrId,
                            	GRP_ID : this.changeGonggiId,
                            	GRP_NM : this.changeGonggiName,
                            	GRP_CLR : this.changeGonggiColor,
                            	GRP_FRM : this.changeGonggiForm,
                            },
                        }
                        cf_ajax("/mb/gm/MBGM0106", options).then(this.modifyGonggiDetailCB);
                    	},
                    cancelCB : () => {return;},
                }
            mb_confirm(option);
        	
        },
        
        modifyGonggiDetailCB : function() {
        	document.getElementById('closeBtn').click();
        	mb_alert({
        		title:"포켓 수정",
        		msg:"수정이 완료되었어요."
        	});
        	this.getDrawer();
        },
        
        // 즐겨찾기 액션
    	setFavorites : function(e, index, myid) {
  			var options = {
                    params : {
                    	mbrId : this.mbrId,
                    	MYNTE_ID : myid,
                    	FAV_YN : this.piece[index].FAV_YN === 'Y' ? 'N' : 'Y', 
                    },
                }
  			if(this.piece[index].FAV_YN === 'Y') {
  				this.piece[index].FAV_YN = 'N';
  			} else if (this.piece[index].FAV_YN === 'N') {
  				this.piece[index].FAV_YN = 'Y';
  			}
  			$(e.target).toggleClass('on');
            cf_ajax("/mb/gm/MBGM0108", options).then();
    	},
    	// 피스 카테고리 액션
    	setSortPiece : function(e, id) {
    		this.sortPiece = id;
            let text = $(e.target).html();
            $(e.target).addClass('on').siblings().removeClass('on');
            const selectValue = $(e.target).closest('.select_wrap').find('.selected_value');
            selectValue.text(text);
            $(e.target).closest('.select_wrap').addClass('on').removeClass('active');
            $('.select_wrap').removeClass('active');
    		this.getPieceList();
    		
    	},
    	
    	// 셀렉트 오픈 액션
    	openSortPieceList : function(e) {
            $(e.className).parent().toggleClass('active');
            $(e.className).closest('.item_area').siblings().find('.select_wrap').removeClass('active');
    	},
    	
    	// 피스 팝업 선택 (내 피스 or 구독한 피스)
    	openModifyLayer : function(ntecrId, nteId, index, grpId) {
    		this.currentScroll = document.querySelector('html').scrollTop;
    		if(this.mbrId === ntecrId ) {
    			vueappModifyPiece.groupList = this.gonggi;
    			vueappModifyPiece.nteId = nteId;
    			vueappModifyPiece.openNteUpd();
    		} else {
    			this.openLayerPopup('slide_layer00_2', null , null, 'orange', null);
    			this.changePieceIndex = index;
    			for (var i = 0; i < this.gonggi.length; i++) {
    				if(grpId === this.gonggi[i].GRP_ID) {
		    			document.getElementById('radion_position0'+i).click();
    				}
				}
    			
    		}
    	},
    	
    	// 모든 left 클래스 삭제
    	removeLeft : function() {
    		$('.list_wrap__item').children().removeClass('left');
    	},
    	
    	// 레이어 팝업 액션
        openLayerPopup : function(layer, grpId, name, color, form, index) {
        	// 포켓 수정이고 첫번째 기본포켓이면 (index == 0) 수정팝업 띄우지 않음
        	if (layer == "slide_layer01" && index == 0)
        		return;
        	
        	if(name !== null) {
	  			this.changeGonggiName = name;	
        	}
        	this.moveGonggiBtn = true;
        	this.changeGonggiId = grpId;
        	this.changeGonggiColor = color;
        	this.changeGonggiForm = form;
        	this.changeGonggiIndex = index;
        	this.swiperGonggi.slideTo(form-1);
        	setTimeout(() => this.gonggiLayerBtn = true, 100);
        	
            const _this = $(this);
            const layerPopup = $("#" + layer);
            const layerObjClose = layerPopup.find(".layer_popup_close");
            const layerObj = layerPopup.find("button, input:not([type='hidden']), select, iframe, textarea, [href], [tabindex]:not([tabindex='-1'])");
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
                
                //$(document).off("keydown.lp_keydown");
                $('body').css({overflow : 'auto' });
            }

            layerObjClose.on("click", layerClose); // 닫기 버튼 클릭 시 레이어 닫기

            $('body').append('<div class="dim"></div>');
            layerPopup.animate({
                bottom: 0
            },200);

            $('.dim').on("click",  layerClose);
			
            /*
            $(document).on("keydown.lp_keydown", function(event) {
                // Esc키 : 레이어 닫기
                const keyType = event.keyCode || event.which;

                if (keyType === 27) {
                	layerClose;
                }
            });
            */
            document.querySelector('html').scrollTop = this.currentScroll;
        },
        
        // 페이지 설정
    	initPage : function() {
    		this.$nextTick(function() {
                document.querySelector('.sub_content').style.overflow = "hidden";
                //삭제 스와이프 [s]
                let touchArea = $(".list_wrap .list_wrap__item:gt(0)");  // gt 는 해당 요소의 다음번째 요소들을 가리킴. 0번째 제외하고 다음꺼부터

                let mouseX,
                    initialX = 0;
                let mouseY,
                    initialY = 0;

                let events = {
                    mouse: {
                        down: "mousedown",
                        move: "mousemove",
                        up: "mouseup",
                    },
                    touch: {
                        down: "touchstart",
                        move: "touchmove",
                        up: "touchend",
                    },
                }
				
                let deviceType = "";
                let rectLeft = touchArea.offset().left;
                let rectTop = touchArea.offset().top;

                const getXY = (e) => {
                    mouseX = (!this.isTouchDevice() ? e.pageX : e.touches[0].pageX) - rectLeft;
                    mouseY = (!this.isTouchDevice() ? e.pageY : e.touches[0].pageY) - rectTop;
                };

                this.isTouchDevice;

                touchArea.on('touchstart', function(event) {
                	vueapp.isSwiped = true;
                    getXY(event);
                    initialX = mouseX;
                    initialY = mouseY;
                });

                touchArea.find('.name_area').on("touchmove",function(event) {
                    const _this = $(this);
                    if(!vueapp.isTouchDevice) {
                        event.preventDefault();
                    }
                    if(vueapp.isSwiped) {
                        getXY(event);
                        let diffX = mouseX - initialX;
                        let diffY = mouseY - initialY;
                        if( diffX > 0 ) {
                            _this.closest('.item_cotent').removeClass('left');
                        } else {
                            _this.closest('.item_cotent').addClass('left');
                            _this.closest('.list_wrap__item').addClass('active').siblings().removeClass('active');
                        }
                    }
                });

                touchArea.on("touchend",function(event){
                	vueapp.isSwiped = false;
                })

                touchArea.on("mouseleave", () => {
                	vueapp.isSwiped = false;
                });
              	//삭제 스와이프 [e]
              	
              	/* 
                $(document).on("keydown.lp_keydown", function(event) {
                    // Esc키 : 레이어 닫기
                    const keyType = event.keyCode || event.which;

                    if (keyType === 27) {
                        this.layerClose();
                    }
                });
    			*/
            });
    	},
    	
    	isTouchDevice : function(){
            try {
                document.createEvent("TouchEvent");
                deviceType = "touch";
                return true;
            } catch (e) {
                deviceType = "mouse";
                return false;
            }
        },
        
        // 탭 변경 시 초기화
        changeTab : function(val) {
        	if(val === 'g') {
        		//this.getPiecesCount();
        		this.getDrawer();
        		//this.sortableGonggi.sort(this.initSortable, true);
        		this.gonggiBtn = true;
        	}
        	if(val === 'p') {
        		this.pieceBtn = true;
        		this.sortPiece = 'ALL';
        		let text = $('#gonggiAll').html();
                $('#gonggiAll').addClass('on').siblings().removeClass('on');
                const selectValue = $('#gonggiAll').closest('.select_wrap').find('.selected_value');
                selectValue.text(text);
                $('#gonggiAll').closest('.select_wrap').addClass('on').removeClass('active');
                $('.select_wrap').removeClass('active');
                this.getDrawer();
        		this.getPieceList();
        	}
       		this.removeLeft();
        },
        
        // 구독한 피스 클릭 시 아이디 저장
        setMoveGonggi : function(val) {
        	this.moveGonggiId = val;
        	if(this.piece[this.changePieceIndex].GRP_ID === val) {
	        	this.moveGonggiBtn = true;
        	} else {
        		this.moveGonggiBtn = false;
        	}
        },
        
        // 구독한 피스의 포켓 위치 변경
        moveGonggi : function() {
        	var options = {
                    params : {
                    	mbrId : this.mbrId,
                    	GRP_ID : this.moveGonggiId,
                    	MYNTE_ID : this.piece[this.changePieceIndex].MYNTE_ID
                    },
                }
            cf_ajax("/mb/gm/MBGM0107", options).then(this.moveGonggiCB);
        },
        moveGonggiCB : function(data) {
        	this.getPieceList();
        	mb_alert({
                title: "포켓 위치 변경",
                msg : "포켓 위치가 변경되었어요.",
                confirmCB : () => {document.getElementById('closeMoveGonggi').click();},
            });
        }
        
    },
});
</script>
<jsp:include page="/WEB-INF/jsp/mb/gm/MBGM0100P01.jsp" flush="true"/>