<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="vueapp">
	<template>
		<div id="container">
	        <div id="content" class="sub_content">
	            <div class="change_pw">
	                <div class="item_area">
	                    <span class="title">현재 비밀번호</span>
	                    <div class="input_wrap input_button">
	                        <div class="input_inner">
	                            <input type="password" v-model="oldPassword" id="oldPassword" placeholder="현재 비밀번호를 입력해 주세요." @keyup="toggleButton" :disabled="!chkCurrent">
	                            <button type="button" class="btn_show" @click="visionPassword('current')" id="visionCurrentPassword"><span class="blind">비밀번호 숨기기</span></button>
	                        </div>
	                        <button type="button" :class="chkCurrent ? 'btn_duplication' : 'btn_duplication black'" @click="pwdCheck" :disabled="!chkCurrent">확인</button>
	                    </div>
	                </div>
	                <!-- 새 비밀번호 error 생길 때 -->
	                <div class="item_area mgTop40" id="errorDiv">
	                    <span class="title">새 비밀번호</span>
	                    <div class="input_wrap">
	                        <div class="input_inner">
	                            <input type="password" v-model="newPassword" id="newPassword" placeholder="새 비밀번호를 입력해 주세요." maxlength="20" :disabled="chkCurrent">
	                            <button type="button" class="btn_show" @click="visionPassword('new')" id="visionNewPassword"><span class="blind">비밀번호 숨기기</span></button>
	                        </div>
	                        <div class="input_inner">
	                            <input type="password" v-model="checkPassword" id="checkPassword" placeholder="새 비밀번호를 다시 입력해 주세요." maxlength="20" :disabled="chkCurrent">
	                            <button type="button"  class="btn_show" @click="visionPassword('check')" id="visionCheckPassword"><span class="blind">비밀번호 숨기기</span></button>
	                        </div>
	                        <div class="error_message" id="regCheck">비밀번호가 형식에 맞지 않아요. 다시 입력해 주세요</div>
		                    <div class="error_message" id="passCheck">새비밀번호가 서로 일치하지 않아요. 다시 입력해 주세요.</div>
	                    </div>
	                    <div class="message">영문/숫자/특수문자를 조합하여 8~20자로 입력해 주세요.</div>
	                </div>
	                <!-- 새 비밀번호 error 생길 때 -->
		            <div class="btn_wrap">
		                <button type="button" class="btn btn--big" :disabled="buttonDisable" @click="validatePwd"><span>비밀번호 변경하기</span></button>
		            </div>
	            </div>
	
        	</div>
   	 	</div>
	</template>
</div>
</div>

<script>
var vueapp = new Vue({
    el : "#vueapp",
    data : {
    	oldPassword : "", //현재 비밀번호
    	newPassword : "", //변경 할 비밀번호
    	checkPassword: "",//변경 할 비밀번호 확인
    	chkCurrent : true,
    	buttonDisable: true,
    	
    },
    watch : {
    	oldPassword : function(value) { 
    		if (value !== '' 
				&& this.newPassword !== '' 
				&& this.checkPassword !== '') {
				this.buttonDisable = false;
			} else {
				this.buttonDisable = true;
			}
    	},
    	newPassword : function(value) {
    		var regExp = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
			if (value.match(regExp)) {
				if(value === this.checkPassword) {
					$('#errorDiv').removeClass("error");
					$('#passCheck').hide();
				} else {
					$('#errorDiv').addClass("error");
					$('#passCheck').show();
					$('#regCheck').hide();
				}
				
			} else {
				$('#errorDiv').addClass("error");
    			$('#passCheck').hide();
    			$('#regCheck').show();
			}
			if (this.oldPassword !== '' 
				&& value !== '' 
				&& this.checkPassword !== '') {
				this.buttonDisable = false;
			} else {
				this.buttonDisable = true;
			}
			if(cf_isEmpty(value) && cf_isEmpty(this.checkPassword)) {
				$('#errorDiv').removeClass("error");
				$('#passCheck').hide();
				$('#regCheck').hide();
			}
    	},
    	checkPassword : function(value) {
    		var regExp = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
    		if(value === this.newPassword) {
    			if (this.newPassword.match(regExp)) {
	    			$('#errorDiv').removeClass("error");
	    			$('#regCheck').hide();
    			} else {
    				$('#errorDiv').addClass("error");
    				$('#passCheck').hide();
	    			$('#regCheck').show();
    			}
    		} else {
    			if (this.newPassword.match(regExp)) {
	    			$('#errorDiv').addClass("error");
	    			$('#passCheck').show();
	    			$('#regCheck').hide();
    			} else {
    				$('#errorDiv').addClass("error");
	    			$('#passCheck').hide();
	    			$('#regCheck').show();
    			}    				
    		}
    		if (this.oldPassword !== '' 
				&& this.newPassword !== '' 
				&& value !== '') {
				this.buttonDisable = false;
			} else {
				this.buttonDisable = true;
			}
    		
    		if(cf_isEmpty(value) && cf_isEmpty(this.newPassword)) {
				$('#errorDiv').removeClass("error");
				$('#passCheck').hide();
				$('#regCheck').hide();
			}
    	},
    },
    methods : {
		validatePwd : function() {
			var regExp = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
			var option = {
	    		title : "비밀번호 변경",
	    		msg : "현재 비밀번호 혹은 새 비밀번호를\n다시 확인해 주세요.",
		    }
			if (this.newPassword.length < 8 || this.checkPassword.length > 20) {
				option = {
			    		title : "회원가입",
			    		msg : "비밀번호를 8~20자 사이로\n입력해 주세요.",
						confirmCB : () => {		
							$("#newPassword").focus();		    			
			    		}
				};
				mb_alert(option);
				return false;
			}
			if (this.newPassword !== this.checkPassword) {
				mb_alert(option);
			}else if (!this.newPassword.match(regExp)) {
				mb_alert(option);
			}else if(this.oldPassword == this.newPassword) {
				mb_alert({
					title : "비밀번호 변경",
					msg : "새 비밀번호가 기존 비밀번호와 같아요.\n새 비밀번호를 다시 입력해 주세요."
				});
			} else {
				option = {
					title : "비밀번호 확인",
		    		msg : "정말 변경할까요?",
		    		confirmTxt : "변경" ,
		    		confirmCB : () => {this.updatePwd();} ,
				}
				mb_confirm(option);
			}
		},
		toggleButton : function() { // 빈칸이 없을시 버튼 사용 가능
			if (this.oldPassword !== '' 
					&& this.newPassword !== '' 
					&& this.checkPassword !== '') {
				this.buttonDisable = false;
			} else {
				this.buttonDisable = true;
			}
		},
		
		newPasswordFocusOut : function() {
			if(this.checkPassword !== ''
				&& this.newPassword !== this.checkPassword) {
				$('#errorDiv').addClass(" error");	
			} else if (this.newPassword === this.checkPassword
					|| this.checkPassword === ''
					|| this.newPassword === '') {
				$('#errorDiv').removeClass(" error");
			}
			
		},
		
		visionPassword : function(val) {
			if(val === 'new') {
				$('#visionNewPassword').toggleClass('show');
	            $('#visionNewPassword').prev('input').attr('type', function(index, attr){
	                return attr == 'text' ? "password" : "text";
	            });	
			} else if (val === 'check') {
				$('#visionCheckPassword').toggleClass('show');
	            $('#visionCheckPassword').prev('input').attr('type', function(index, attr){
	                return attr == 'text' ? "password" : "text";
	            });
			} else if (val === 'current') {
				$('#visionCurrentPassword').toggleClass('show');
	            $('#visionCurrentPassword').prev('input').attr('type', function(index, attr){
	                return attr == 'text' ? "password" : "text";
	            });
			}
		},
		
		updatePwd : function() {
			var options = {
				params : {
					oldPassword : this.oldPassword.trim(),
					newPassword : this.newPassword.trim(),	
				},
			};
			cf_ajax("/mb/pc/MBPC0101", options).then(this.updatePwdCB);
		}, 
		updatePwdCB : function(data) {
			if(data.result == 1) {
				var option1 = {
			    		title : "비밀번호 변경",
			    		msg : "현재 비밀번호가 일치하지 않아요.\n 다시 입력해 주세요.",
			    }
				mb_alert(option1);
			} else {
				var option2 = {
			    		title : "비밀번호 변경",
			    		msg : "변경이 완료되었어요.",
			    		confirmTxt : "메인으로" ,
			    		confirmCB : () => {cf_movePage('/mb/mn/MBMN0100');},
			    }
				mb_alert(option2);
			}
		},
		pwdCheck : function() {
			var options = {
					params : {
						oldPassword : this.oldPassword.trim(),
					},
				};
				cf_ajax("/mb/pc/MBPC0102", options).then(this.pwdCheckCB);
		},
		pwdCheckCB : function(data) {
			if(data.result === 'sucess')
				mb_alert({
					title : "비밀번호 변경",
					msg : "현재 비밀번호가 확인되었어요.\n새 비밀번호를 입력해 주세요.",
					confirmCB : () => {this.chkCurrent = false}
				})
			else if (data.result === 'regFail')
				mb_alert({
					title : "비밀번호 변경",
					msg : "비밀번호를 형식에 맞추어 입력해 주세요."
				})
			else if (data.result === 'fail')
				mb_alert({
					title : "비밀번호 변경",
					msg : "비밀번호가 일치하지 않습니다."
				})
		}
	
    },
});
</script>