<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="withdrawal" id="withdrawVueapp">
	<template>
		<div class="full_popup">
		    <div class="full_popup__header">
		        <h2 class="title">회원탈퇴</h2>
		        <button type="button" class="popup_close" @click="closePopup"><span class="blind">팝업닫기</span></button>
		    </div>
		    <div class="full_popup__body padBottom0">
		        <div class="withdrawn_warp">
		            <p class="big_text mgBottom20">잠깐! 밈플을 탈퇴하기 전에 아래 정보를 꼭 확인해주세요 😥</p>
		            <ul>
		                <li>계정 정보는 1주일 보관 후 모두 폐기돼요.</li>
		                <li>포켓/피스 모든 데이터를 다시 볼 수 없어요.</li>
		                <li>탈퇴 이유를 한가지 이상 선택해 주세요.</li>
		            </ul>
		            <p class="big_text">왜 떠나시는지 이유가 있을까요?<br>더 나은 서비스를 위해 노력하겠습니다! (복수선택이 가능해요)</p>
		            <div class="checkbox_list">
		                <div class="checks" v-for="(item, index) in code">
		                	<input type="checkbox" name="" :id="'ck'+(index+1)" v-model="etcCheck" v-if='item.SUB_CAT_CD === "ETC"'><label :for="'ck'+(index+1)" v-if='item.SUB_CAT_CD === "ETC"'>기타(직접입력)</label>
		                    <input type="checkbox" name="" :id="'ck'+(index+1)" v-model="reason" :value="'0' + (index+1) + item.SUB_CAT_CD" v-else><label :for="'ck'+(index+1)" v-if='item.SUB_CAT_CD !== "ETC"'>{{item.SUB_CAT_DESC}}</label>
		                    <div class="text_area" v-if='item.SUB_CAT_CD === "ETC"'>
		                        <textarea v-model="etcText" name="" id="" cols="30" rows="10" maxlength="100" placeholder="이유를 10자 이상 입력해 주세요.&#13;&#10;(최대 100자까지 입력 가능해요.)" :disabled="!etcCheck"></textarea>
		                    </div>
		                    <div class="text_count" v-if='item.SUB_CAT_CD === "ETC"'>{{etcCount}} / 100 자</div>
		                </div>
		            </div>
		            <p class="big_text">마지막으로 회원 탈퇴를 위해 회원님의 비밀번호를 입력해 주세요.</p>
		            <div class="input_wrap input_type2">
		                <div class="input_inner">
		                    <input type="password" v-model="password" placeholder="비밀번호를 입력해 주세요." maxlength="20" :disabled="checkPassword">
		                    <button type="button" class="btn_show" id="visionPassword" @click="visionPassword"><span class="blind">비밀번호 숨기기</span></button>
		                </div>
		                <button type="button" :class="!checkPassword ? 'btn_send' : 'btn_send black'" @click="goCheckPassword()" :disabled="checkPassword">확인</button>
		            </div>
		        </div>
		        <div class="btn_wrap">
		            <!--<button type="button" class="btn btn&#45;&#45;big" onclick="common.alertLayer('' +'member04')"><span>탈퇴하기</span></button>-->
		            <button type="button" class="btn btn--big" @click="goWithdrawal" :disabled="btnDisable"><span>탈퇴하기</span></button>
		        </div>
		    </div>
		</div>
	</template>
</div>

<script>

var withdrawVueapp = new Vue({
    el : "#withdrawVueapp",
    data : {
    	code : [],
    	reason : [], // 체크된 탈퇴 사유
    	etcCount : 0, // 기타 사유 글자 수
    	etcText : "", // 기타 사유
    	etcCheck : false, // 기타 사유 체크 여부
    	password : "", 
    	checkPassword : false,
    	btnDisable : true,
    },
    watch : {
    	etcText : function(value) {
    		this.etcCount = value.length;
    	},
    },
    mounted : function() {
    	$('.withdrawal').hide();
		$('.popup_close').on("click", function() {
			if ($('.withdrawal').is(':visible')) {
				$('.withdrawal').hide();
				$('#wrap').show();
				window.scrollTo(0,vueapp.currentScroll);
			} else {
				$('.withdrawal').show();
				$('#wrap').hide();
			}
		});
		this.getCode();
    },
    methods : {
    	// 탈퇴 이유 불러오기
    	getCode : function() {
    		var options = {
					params : {},
				};
			cf_ajax("/mb/pi/MBPI0100P01/getCode", options).then(this.getCodeCB);
    	},
		getCodeCB : function(data) {
    		this.code = data;
    	},
    	// 비밀번호 확인
    	goCheckPassword : function() {
    		var options = {
					params : {
						password : this.password,
					},
				};
			cf_ajax("/mb/pi/MBPI0100P01/checkPassword", options).then(this.goCheckPasswordCB);
    	},
    	goCheckPasswordCB : function(data) {
    		if(data.result === "success") {
    			var option = {
			    		title : "회원 탈퇴",
			    		msg : "비밀번호가 확인되었어요.",
				};
				mb_alert(option);
				this.checkPassword = true;
				this.btnDisable = false;
    		} else if(data.result === "fail") {
    			var option = {
			    		title : "회원 탈퇴",
			    		msg : "비밀번호가 일치하지 않아요.\n다시 입력해 주세요.",
				};
				mb_alert(option);
    		}
    		
    	},    	
    	
    	// 회원 탈퇴
    	goWithdrawal : function() {
    		if(!this.checkPassword) {
    			mb_alert({
    				title : "회원 탈퇴",
    				msg : "먼저 비밀번호를 확인해 주세요."
    			});
    			return;
    		}
    		if(this.reason.length < 1 && !this.etcCheck) {
    			mb_alert({
    				title : "회원 탈퇴",
    				msg : "회원 탈퇴 이유를 하나 이상 선택해 주세요."
    			});
    			return;
    		}
    		// 기타 이유 체크 시 체크
    		if(this.etcCheck) {
    			if(this.etcText.length < 10) {
    				mb_alert({
    					title : "회원 탈퇴",
    					msg : "기타 이유를 10자 이상 입력해 주세요."
    				})
    				return;
    			}
    			// reason에 '기타' 이유 푸시
    			this.reason.push('05ETC');
    		}
    		var option = {
    				title : "회원 탈퇴",
    	    		msg : "정말로 탈퇴하시겠어요?",
    	    		confirmTxt : "떠날래요" ,
    	    		confirmCB : () => {
    	    			this.reason.sort();
    	        		for (var i = 0; i < this.reason.length; i++) {
    	    				this.reason[i] = this.reason[i].substr(2); 
    	    			}
    	    			var options = {
    						params : {
    							reason : this.reason.toString(),
    							etcText : this.etcCheck ? this.etcText : '',
    						},
    					};
    				cf_ajax("/mb/pi/MBPI0100P01/goWithdrawal", options).then(this.goWithdrawalCB)} ,
    	    		cancelTxt : "더 써볼래요",
    	    		cancelCB : () => {}
    			};
   			mb_confirm(option);
    		
    	},
    	
    	goWithdrawalCB : function() {
   			mb_alert({
   				title : '회원 탈퇴',
   				msg : '회원탈퇴가 완료되었어요.',
   				confirmTxt : '로그아웃',
   				confirmCB : () => { cf_movePage('/logout');},
   			});
    	},
    	
    	// 비밀번호 표시
    	visionPassword : function() {
			$('#visionPassword').toggleClass('show');
           	$('#visionPassword').prev('input').attr('type', function(index, attr){
            	return attr == 'text' ? "password" : "text";
           	});
		},
    	
		closePopup : function() {
			$('.btn_show').click();
		}
    },
});
</script>