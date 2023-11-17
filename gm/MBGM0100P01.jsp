<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<div id="vueappModifyPiece" class="nteUpd">
	<template>
		<div class="full_popup">
			<div class="full_popup__header">
				<h2 class="title">피스수정</h2>
				<button type="button" class="popup_close popNteUpdClose" @click="moveScroll">
					<span class="blind">팝업닫기</span>
				</button>
			</div>
			<div class="full_popup__body">
				<!-- 포켓 이름 -->
				<div class="item_area">
					<span class="title essential">포켓 이름</span>
					<div class="select_wrap grpNm" :class="{on : nteData.GRP_ID !==''}">
						<div class="selected_value" v-if="nteData.GRP_ID !==''">{{grp.GRP_NM}}</div>
						<div class="selected_value" v-else>포켓을 선택해 주세요.</div>
						<div class="option_wrap">
							<ul class="option_list">
								<li class="option" v-for="gg in groupList" @click="setGrp(gg)"
									:id="gg.GRP_ID" :class="{on : gg.GRP_ID === grp.GRP_ID}">{{gg.GRP_NM}}</li>
							</ul>
						</div>
					</div>
				</div>
				<!-- //포켓 이름 -->

				<!-- 카테고리 분류 -->
				<div class="item_area">
					<span class="title essential">카테고리 분류</span>
					<div class="select_wrap ctNm" :class="{on : nteData.NTE_CAT_CD !== ''}">
						<div class="selected_value" v-if="nteData.NTE_CAT_CD !== ''">{{nteData.NTE_CAT_NM}}</div>
						<div class="selected_value" v-else>카테고리를 선택해 주세요.</div>
						<div class="option_wrap">
							<ul class="option_list">
								<li class="option" v-for="(ct,idx) in cateList"
									@click="setCt(ct)" :id="ct.SUB_CAT_CD"
									:class="{on : ct.SUB_CAT_CD === nteData.NTE_CAT_CD}">{{ct.SUB_CAT_NM}}</li>
							</ul>
						</div>
					</div>
				</div>
				<!-- //카테고리 분류 -->

				<!-- 피스 유형 -->
				<div class="item_area">
					<span class="title essential">피스유형</span>
					<div class="select_wrap">
						<div class="selected_value nteTyp">{{ nteTyp[nteData.NTE_SORT_TYP_CD] || '피스유형 선택해 주세요.'}}</div>
<!-- 						<div class="option_wrap"> -->
<!-- 							<ul class="option_list"> -->
<!-- 								<li class="option">일자형</li> -->
<!-- 								<li class="option">주제형</li> -->
<!-- 							</ul> -->
<!-- 						</div> -->
					</div>
				</div>
				<!-- //피스 유형 분류 -->

				<!-- 피스 유형 -->
				<div class="item_area">
					<span class="title essential">피스명</span>
					<div class="input_wrap">
						<div class="input_inner">
							<input type="text" :value="nteNm" maxlength="20" @input="chgNm"
								placeholder="피스명을 입력해주세요. (최대 20자 이내)">
							<button type="button" class="btn_delete">
								<span class="blind">삭제</span>
							</button>
						</div>
					</div>
				</div>
				<!-- //피스 유형 분류 -->

				<!-- 피스 설명글 -->
				<div class="item_area">
					<span class="title">피스 설명글</span>
					<div class="text_area">
						<textarea cols="30" rows="10" maxlength="50"
							v-model="nteDesc"
							@input="chgDesc"
							@keydown.enter.prevent
							placeholder="피스의 설명글을 입력해주세요.&#13;&#10;(최대 50자까지 입력 가능합니다.)"></textarea>
					</div>
					<div class="text_count" v-if="nteData.NTE_DESC">{{nteDesc.length}}
						/ 50 자</div>
				</div>
				<!-- //피스 유형 분류 -->

				<div class="item_area">
					<span class="title">피스 대표 이미지</span>
					<div class="image_wrap">
						<input type="file" id="nteImgfile" class="upload_hidden" accept="image/png, image/jpeg" @change="uploadImg" hidden/>
						<button type="button" class="btn_photo" @click="($('#nteImgfile').click())"><span class="current">{{nteImgCnt}}</span> / 1</span></button>
						<div class="photo_list">
							<div class="item" v-if="nteImg !== ''">
								<img :src="'/common/fileDn?p=' + nteImg"  alt="피스 대표 이미지">
								<button type="button" class="btn_del" @click="removeImg">
									<span class="blind">사진 삭제</span>
								</button>
							</div>
						</div>
					</div>
					<p class="tip_text">JPEG, JPG, PNG 사진 최대 1개까지 등록 가능합니다.</p>
				</div>

				<div class="btn_wrap fixed">
					<button type="button" class="btn btn--big" @click="saveNte">
						<span>수정하기</span>
					</button>
				</div>
			</div>
		</div>
	</template>
</div>

<script>
var vueappModifyPiece = new Vue({
	el : "#vueappModifyPiece",
	mounted : function() {
		$('#vueappModifyPiece').hide();
		// 홈 버튼
		$('.popNteUpdClose').on("click", function() {
			/* $('#vueappModifyPiece').hide();
			$('#wrap').show(); */
		});
	},
	data : {
		nteTyp:{
			"TIME":"일자형",
			"SUBJ":"주제형"
		},
		nteData : {},
		ctg: {},
		groupList : [],
		cateList: [],
		grp: {},
		nteCt:"",
		grpId : "",
		nteCatCd : "",
		nteId : '',
		nteNm : "",
		nteDesc : "",
		nteImg : "",
		nteImgCnt: 0,
	},
	methods : {
		openNteUpd: function(){
			window.scrollTo(0,0);
			$('#wrap').hide();
			$('#vueappModifyPiece').show();
			this.getData();
		},
		getData : async function(isInit) {
			var options = {
    				params : {
    					nteId : this.nteId,
    				},
    		}
    		await cf_ajax("/mb/gm/MBGM0100P01/initData", options).then(this.getDataCB);
		},
		getDataCB : function(data) {
			if (data.rsltStatus === 'SUCC') {
				this.nteData = {
						...data.rsltData, 
						NTE_CAT_NM: data.rsltData.NTE_CAT_NM.substring(data.rsltData.NTE_CAT_NM.indexOf(",") + 1)
						};
				this.groupList = data.rsltList;
				this.nteData.NTE_IMG !== "" ? this.nteImgCnt = 1 : this.nteImgCnt = 0;
				this.cateList = data.categoryList.map(ct => {
					  return {
					    ...ct,
					    SUB_CAT_NM: ct.SUB_CAT_NM.substring(ct.SUB_CAT_NM.indexOf(",") + 1)
					  }
				})
	 			this.grp.GRP_ID = this.nteData.GRP_ID;
	 			this.grp.GRP_NM = this.nteData.GRP_NM;
				this.nteCatCd = this.nteData.NTE_CAT_CD;
				this.nteNm = this.nteData.NTE_NM;
				this.nteDesc = this.nteData.NTE_DESC;
				this.nteImg = this.nteData.NTE_IMG;
			}
		},
		setCt : function(val){
			this.ctg = val;
			this.nteData.NTE_CAT_CD = val.SUB_CAT_CD;
			this.nteData.NTE_CAT_NM = val.SUB_CAT_NM;
	        $("#"+val.SUB_CAT_CD).addClass('on').siblings().removeClass('on');
	        $('.ctNm').addClass('on').removeClass('active');
		},
		setGrp : function(val){
			this.grp = val;
// 			this.nteData.GRP_ID = val.GRP_ID;
// 			this.nteData.GRP_NM = val.GRP_NM;
	        $("#"+val.GRP_ID).addClass('on').siblings().removeClass('on');
	        $('.grpNm').addClass('on').removeClass('active');
		},
		chgNm : function(e){
			if (e.target.value.length <= 20) {
    			this.nteNm = e.target.value;
    		}
		},
		chgDesc : function(e){
			this.nteDesc = e.target.value;
		},
		uploadImg : function() {
    		var fileList = [];
    		if (!cf_isEmpty($("#nteImgfile")[0])) {
    			fileList.push($("#nteImgfile")[0].files[0]);
    		}
    		
    		var options = {
    				fileList : fileList,
    				params : {},
    		}
    		
    		cf_ajax("/mb/gm/MBGM0100P01/uploadImage", options).then(this.uploadImgCB);
    	},
    	uploadImgCB : function(data) {
    		var fileInfoList = data.dataList;
    		if (!cf_isEmpty(fileInfoList[0])) {
    			this.nteImg = fileInfoList[0].STOR_FILE_NM;
    			this.nteImgCnt = 1;
    		} else {
    			this.removeImage();
    		}
    	},
    	removeImg: function(){
// 			this.nteData.NTE_IMG = "";
			this.nteImg = "";
			this.nteImgCnt = 0;
			
		},
		saveNte: function(){
			if(cf_isEmpty(this.nteNm)) {
				mb_alert({
					title: "피스 수정",
					msg: "피스 제목을 입력해주세요."
				})
				return;
			}
			
			var options = {
					params : {
						nteId : this.nteData.NTE_ID,
						grpId : this.grp.GRP_ID,
						nteCatCd : this.nteCatCd,
						nteNm : this.nteNm,
						nteDesc : this.nteDesc,
						nteImg : this.nteImg,
					},
				}
			cf_ajax("/mb/gm/MBGM0100P01/saveModNote", options).then(this.saveNteCB);
    	},
    	saveNteCB : async function(data) {
    		if (data.rsltStatus === "SUCC") {
    			var options = {
    					title: '피스 수정',
    					msg: '피스가 수정되었어요.',
    			}
     			mb_alert(options);
    			
    			await vueapp.getPieceList();
    			//vueapp.getPiecesCount();
    			this.moveScroll();
    			
    		}
    	},
    	
    	moveScroll : function() {
    		$('#vueappModifyPiece').hide();
			$('#wrap').show();
			
    		this.$nextTick(function() {
   				document.querySelector('html').scrollTop = vueapp.currentScroll;
  		    });
    		
    	}
	},
});



$(function(){
    $('.selected_value').on('click',function(e){
		// 피스유형 선택불가
    	if($(this).hasClass('nteTyp')) return;
        $(this).parent().toggleClass('active');
        $(this).closest('.item_area').siblings().find('.select_wrap').removeClass('active');
    });

    $(document).on('click', function(e) {
        const $clicked = $(e.target);
        if (!$clicked.parents().hasClass('select_wrap')){
            $('.select_wrap').removeClass('active');
        }
    });
});
</script>