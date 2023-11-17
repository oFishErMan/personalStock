<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="vueapp">
	<template>
		<div class="full_popup">
		    <div class="full_popup__header">
		        <h2 class="title">회원가입</h2>
		        <button type="button" class="popup_close" @click="confirmClose()"><span class="blind">팝업닫기</span></button>
		    </div>
		    <div class="full_popup__body padBottom5">
		        <div class="join_membership">
		            <div class="item_area" id="emailWrap">
		                <span class="title essential">이메일</span>
		                <div class="input_wrap input_type1">
		                    <div class="input_inner">
		                        <input type="email" v-model="userEmail" id="userEmail" placeholder="이메일을 입력해 주세요." autocomplete="off" >
		                        <button type="button" class="btn_delete" @click="userEmail = ''"><span class="blind">삭제</span></button>
		                    </div>
		                    <button type="button" class="btn_send black" id="reSendBtn" v-if="isCertificated">인증완료</button>
		                    <button type="button" class="btn_send" id="reSendBtn" v-else-if="isSendEmail" @click="sendEmail">재전송</button>
		                    <button type="button" class="btn_send" id="sendBtn" v-else @click="sendEmail">인증요청</button>
		                </div>
		                <div class="error_message">이메일 인증요청을 해주세요.</div>
		            </div>
		            <div class="item_area" id="certWrap">
		                <span class="title essential">인증번호</span>
		                <div class="input_wrap input_type2">
		                    <div class="input_inner">
		                        <input type="number" :disabled="!isSendEmail" v-model="userCertificationNumber" id="userCert" placeholder="6자리를 입력해 주세요." @input="maxCertNum">
		                        <button type="button" class="btn_delete" @click="userCertificationNumber = ''"><span class="blind">삭제</span></button>
		                    </div>
		                    <button type="button" id="certBtn" class="btn_send"   @click="certificationNumberCheck">확인</button>
		                </div>
	                    <div class="error_message">이메일 인증번호를 확인해 주세요.</div>
		            </div>
		
		            <div class="item_area" id="pwdWrap">
		                <span class="title essential">비밀번호</span>
		                <div class="input_wrap">
		                    <div class="input_inner">
		                        <input type="password" v-model="userPassword" name="" id="pw1" placeholder="비밀번호를 입력해 주세요." maxlength="20" >
		                        <button type="button" class="btn_show" @click="visionPassword('new')" id="visionPassword"><span class="blind">비밀번호 숨기기</span></button>
		                    </div>
		                    <div class="input_inner">
		                        <input type="password" v-model="userPasswordCheck" name="" id="pw2" placeholder="비밀번호를 다시 입력해 주세요." maxlength="20"  >
		                        <button type="button" class="btn_show" @click="visionPassword('check')" id="visionPasswordCheck"><span class="blind">비밀번호 숨기기</span></button>
		                    </div>
		                    <div class="error_message" id="regCheck">비밀번호가 형식에 맞지 않아요. 다시 입력해 주세요.</div>
		                    <div class="error_message" id="passCheck">비밀번호가 서로 일치하지 않아요. 다시 입력해 주세요.</div>
		                </div>
		                <div class="message">영문/숫자/특수문자를 조합하여 8~20자로 입력해 주세요.</div>
		            </div>
		
		            <div class="item_area" id="nickWrap">
		                <span class="title essential">닉네임</span>
		                <div class="input_wrap input_type1">
		                    <div class="input_inner">
		                        <input type="email" v-model="userNickname" id="userNick" placeholder="닉네임을 입력해 주세요." maxlength="6" >
		                        <button type="button" class="btn_delete" @click="userNickname = ''"><span class="blind">삭제</span></button>
		                    </div>
		                    <button type="button" id="nickBtn" class="btn_send"   @click="nickCheck">중복확인</button>
		                </div>
	                    <div class="error_message">닉네임 중복확인을 해주세요.</div>
		                <div class="message">영문/숫자/한글을 조합하여 2~6자로 입력해 주세요.</div>
		            </div>
		
		            <div class="item_area">
		                <span class="title">성별</span>
		                <div class="input_wrap input_both">
		                    <div class="radio_btn"><input type="radio" name="gender" id="gender1" @click="setGender('M')"><label for="gender1">남</label></div>
		                    <div class="radio_btn"><input type="radio" name="gender" id="gender2" @click="setGender('F')"><label for="gender2">여</label></div>
		                </div>
		            </div>
		
		            <div class="item_area">
		                <span class="title">생년월일</span>
		                <div class="input_wrap">
		                    <div class="input_inner" >
		                        <input type="text" v-model="userBirthday" maxlength="10" @keyup="setBirth()" id="openDtmPicker" placeholder="ex. 19800101" min="" max="">
		                        <button type="button" class="btn_delete" style="display: inline-block;" @click="userBirthday = ''"><span class="blind">삭제</span></button>
		                    </div>
		                </div>
		                <div class="message">생년월일은 8자리의 숫자로 입력해 주세요.</div>
		            </div>
		
		            <div class="agree_wrap">
		                <div class="total_check checks" >
		                    <input type="checkbox" v-model="allChked" :value="allChked" id="agree_all" @click="setAllCheck($event.target.checked)"><label for="agree_all">전체동의</label>
		                </div>
		                <div class="check_list">
		                    <div class="item checks checks--type1" >
		                        <input type="checkbox" v-model="checkToS1" :value="checkToS1" id="agree_01"   ><label for="agree_01">서비스 이용약관<span class="color_orange">(필수)</span></label>
		                        <a href="#" @click="goTC(event, 'USE')"><span class="blind">약관 전문보기</span></a>
		                    </div>
		                    <div class="item checks checks--type1" >
		                        <input type="checkbox" v-model="checkToS2" :value="checkToS2" id="agree_02"   ><label for="agree_02">개인정보 수집 및 이용동의<span class="color_orange">(필수)</span></label>
		                        <a href="#" @click="goTC(event, 'PRIV')"><span class="blind">약관 전문보기</span></a>
		                    </div>
		                    <div class="item checks checks--type1" >
		                        <input type="checkbox" v-model="checkToS3" :value="checkToS3" id="agree_03"   ><label for="agree_03">개인정보 마케팅 활용동의<span class="color_gray">(선택)</span></label>
		                        <a href="#" @click="goTC(event, 'MKT')"><span class="blind">약관 전문보기</span></a>
		                    </div>
		                </div>
		            </div>
		        </div>
		        <div class="btn_wrap fixed3">
		            <button type="button" class="btn btn--big" @click="addAccount"><span>회원가입 완료</span></button>
		        </div>
		    </div>
		</div>
	</template>
</div>

<script>
var vueapp = new Vue({
    el : "#vueapp",
    watch : {
    	checkToS1 : function(value) {
    		if (value && this.checkToS2 && this.checkToS3) {
    			this.allChked = true;
    		} else {
    			this.allChked = false;
    		}
    	},
    	checkToS2 : function(value) {
    		if (value && this.checkToS1 && this.checkToS3) {
    			this.allChked = true;
    		} else {
    			this.allChked = false;
    		}
    	},
    	checkToS3 : function(value) {
    		if (value && this.checkToS2 && this.checkToS1) {
    			this.allChked = true;
    		} else {
    			this.allChked = false;
    		}
    	},
    	//비밀번호 실시간 체크 테두리 및 메세지
    	userPassword : function(value) {
    		var regExp = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
			if (value.match(regExp)) {
				if(value === this.userPasswordCheck) {
					$('#pwdWrap').removeClass("error");
					$('#passCheck').hide();
				} else {
					$('#pwdWrap').addClass("error");
					$('#passCheck').show();
					$('#regCheck').hide();
				}
			} else {
				$('#pwdWrap').addClass("error");
    			$('#passCheck').hide();
    			$('#regCheck').show();
			}
			if(cf_isEmpty(value) && cf_isEmpty(this.userPasswordCheck)) {
				$('#pwdWrap').removeClass("error");
				$('#passCheck').hide();
				$('#regCheck').hide();
			}
    	},
    	//비밀번호 실시간 체크 테두리 및 메세지
    	userPasswordCheck : function(value) {
    		var regExp = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
    		if(value === this.userPassword) {
    			if (this.userPassword.match(regExp)) {
	    			$('#pwdWrap').removeClass("error");
	    			$('#regCheck').hide();
    			} else {
    				$('#pwdWrap').addClass("error");
    				$('#passCheck').hide();
	    			$('#regCheck').show();
    			}
    		} else {
    			if (this.userPassword.match(regExp)) {
	    			$('#pwdWrap').addClass("error");
	    			$('#passCheck').show();
	    			$('#regCheck').hide();
    			} else {
    				$('#pwdWrap').addClass("error");
	    			$('#passCheck').hide();
	    			$('#regCheck').show();
    			}    				
    		}
    		if(cf_isEmpty(value) && cf_isEmpty(this.userPassword)) {
				$('#pwdWrap').removeClass("error");
				$('#passCheck').hide();
				$('#regCheck').hide();
			}
    		
     	},
     	userEmail : function(value) {
	     	this.isCertificated = false;
	     	this.isSendEmail = false;
	     	$("#sendBtn").attr("disabled",false);
	     	$("#reSendBtn").attr("disabled",false);
	     	$("#reSendBtn").removeClass("black");
	     	$("#emailWrap").removeClass("error");
	     	this.userCertificationNumber = "";
     	},
     	
     	userCertificationNumber : function(value) {
     		this.isCertificated = false;
     		$("#certBtn").attr("disabled",false);
     		$("#certBtn").removeClass("black");
     		$("#certWrap").removeClass("error");
     		
     	},
     	
     	userNickname : function(value) {
     		this.isNotDuplicationNick = false;
     		$("#nickBtn").attr("disabled",false);
     		$("#nickBtn").removeClass("black");
     		$("#nickWrap").removeClass("error");
     	},
     	userBirthday : function(value) {
     		var reg = /[^0123456789-]/g;
    		if(event.keyCode != 8) {
	    		if(reg.test(value)) {
	    			if(this.userBirthday.length !== 1) {
		    			this.userBirthday = this.userBirthday.substr(0,this.userBirthday.length-1);
	    			} else {
	    				this.userBirthday = '';
	    			}
	    			mb_alert({
	    				title : "회원가입",
	    				msg : "생년월일은 숫자만 입력해 주세요."
	    			})
	    		}
    		}
     	}
    },
    mounted : function() {
    },
    data : {
    	userEmail : '',
    	saveUserEmail : '',
    	userCertificationNumber : '',
    	userPassword : '',
    	userPasswordCheck : '',
    	userNickname : '',
    	userGender : '',
    	userBirthday : '',
    	dtmIntervalId : '',
    	isSendEmail : false,
    	isCertificated : false, //이메일 인증번호 확인
    	isNotDuplicationNick : false, //닉네임 중복확인
    	checkToS1 : false,
    	checkToS2 : false,
    	checkToS3 : false,
    	allChked : false,
    	currentScroll : 0,
    },
    methods : {
		validateInformation : function() {
			//이메일 검증
			if(!this.isSendEmail) {
				mb_alert({
					title : "회원가입",
					msg : "먼저 이메일 인증요청을 해주세요.",
					confirmCB : () => {
						window.scrollTo(0,0);
						$("#userEmail").focus();
						$("#emailWrap").addClass("error");
					}
				})
				return false;
			}
			//인증번호 검증
			if(!this.isCertificated) {
				mb_alert({
					title : "회원가입",
					msg : "먼저 이메일 인증번호를 확인해 주세요.",
					confirmCB : () => {
						window.scrollTo(0,0);
						$("#userCert").focus();
						$("#certWrap").addClass("error");
					}
				})
				return false;
			}
			//비밀번호 검증
			var regExp = /^.*(?=^.{8,20}$)(?=.*\d)(?=.*[a-zA-Z])(?=.*[!@#$%^&+=]).*$/;
			var option = {
	    		title : "회원가입",
	    		msg : "",
		    }
			if (cf_isEmpty(this.userPassword)) {
				option = {
			    		title : "회원가입",
			    		msg : "먼저 비밀번호를 입력해 주세요.",
			    		confirmCB : () => {
			    			window.scrollTo(0,0);
			    			$("#pw1").focus();
			    		}
				};
				mb_alert(option);
				return false;
			}
			if (cf_isEmpty(this.userPasswordCheck)) {
				option = {
			    		title : "회원가입",
			    		msg : "먼저 비밀번호 확인을 입력해 주세요.",
			    		confirmCB : () => {
			    			$("#pw2").focus();
			    		}
			    		
				};
				mb_alert(option);
				return false;
			}
			if (!this.userPassword.match(regExp)) {
				option = {
			    		title : "회원가입",
			    		msg : "비밀번호를 형식에 맞춰 입력해 주세요.",
						confirmCB : () => {
							$("#pw1").focus();
			    		}
				};
				mb_alert(option);
				return false;
			}
			if (this.userPassword !== this.userPasswordCheck) {
				option = {
			    		title : "회원가입",
			    		msg : "비밀번호가 서로 일치하지 않아요.",
						confirmCB : () => {		
							$("#pw2").focus();		    			
			    		}
				};
				mb_alert(option);
				return false;
			}
			
			if (this.userPassword.length < 8 || this.userPassword.length > 20) {
				option = {
			    		title : "회원가입",
			    		msg : "비밀번호를 8~20자 사이로\n입력해 주세요.",
						confirmCB : () => {		
							$("#pw1").focus();		    			
			    		}
				};
				mb_alert(option);
				return false;
			}
			//닉네임 검증
			if(!this.isNotDuplicationNick) {
				mb_alert({
					title : "회원가입",
					msg : "먼저 닉네임 중복확인을 해주세요.",
					confirmCB : () => {
						$("#userNick").focus();
						$("#nickWrap").addClass("error");
					}
				})
				return false;
			}
			
			if (this.userNickname.length < 2 || this.userNickname.length > 6 ) {
				option = {
			    		title : "회원가입",
			    		msg : "닉네임을 2~6자로 입력해 주세요.",
			    		confirmCB : () => {
							$("#userNick").focus();
							$("#nickWrap").addClass("error");
						}
				};
				mb_alert(option);
				return false;
			}
			
			if(!this.checkToS1 || !this.checkToS2 ) {
				option = {
			    		title : "회원가입",
			    		msg : "필수 약관에 동의해야 가입할 수 있어요.",
				};
				mb_alert(option);
				return false;
			}
			
			return true;
		},
		sendEmail : function() {
			var emailRegex = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
			if (!emailRegex.test(this.userEmail)) {
				var option = {
			    		title : "회원가입",
			    		msg : "이메일을 형식에 맞춰 적어주세요.",
				};
				mb_alert(option);
				return;
			} else {
				mb_confirm({
					title : "회원가입",
					msg : this.userEmail + "\n위 주소로 이메일을 전송할까요?",
					confirmTxt : "전송",
					confirmCB : () => {
						var options = {
								params : {
									email : this.userEmail,
									
								},
							};
						cf_ajax("/mb/mj/MBMJ0101", options).then(this.sendEmailCB);
					}
				})
			}
		},
		sendEmailCB : function(data) {
			this.userCertificationNumber = "";
			if(data.result === 'duplicated') {
				var option = {
			    		title : "회원가입",
			    		msg : "이미 사용중인 이메일이에요.",
				};
				mb_alert(option);
			} else if(data.result === 'sucess') {
				this.isSendEmail = true;
				$("#certBtn").removeClass("black");
				var option = {
			    		title : "회원가입",
			    		msg : "이메일을 전송했어요.",
				};
				mb_alert(option);
				$("#emailWrap").removeClass("error");
				$("#userCert").attr("disabled",false);
			}
		},
		
		certificationNumberCheck : function() {
			if(!this.isSendEmail) {
				var option = {
			    		title : "회원가입",
			    		msg : "이메일 인증 요청을 먼저 해주세요.",
				};
				mb_alert(option);
				return;
			} 
			var options = {
					params : {
						EMAIL : this.userEmail,
						EMAIL_CRT_NO : this.userCertificationNumber,
					},
				};
			cf_ajax("/mb/mj/MBMJ0102", options).then(this.certificationNumberCheckCB);
		},
		certificationNumberCheckCB : function(data) {
			if(data.result === 1) {
				this.isCertificated = true;
				$("#certBtn").attr("disabled",true);
				$("#certBtn").addClass("black");
				$("#userCert").attr("disabled",true);
				$("#userEmail").attr("disabled",true);
				
				var option = {
			    		title : "회원가입",
			    		msg : "인증이 완료되었어요.",
				};
				mb_alert(option);
				$("#certWrap").removeClass("error");
			} else {
				var option = {
			    		title : "회원가입",
			    		msg : "올바르지 않은 인증번호예요. \n 다시 입력해 주세요. ",
				};
				mb_alert(option);
			}
			
		},
		
		nickCheck : function() {
			const regex = /^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9|]+$/;
			if(this.userNickname.length < 2 || this.userNickname.length > 6) {
				var option = {
			    		title : "회원가입",
			    		msg : "닉네임을 2~6자로 입력해 주세요.",
				};
				mb_alert(option);
				return;
			}
			if(!regex.test(this.userNickname)) {
				mb_alert({
					title : "회원가입",
					msg : "닉네임은 영문, 숫자, 한글을 사용해 주세요."
				})
				return;
			}
			var blank_pattern = /[\s]/g;
			if(blank_pattern.test(this.userNickname)){
				mb_alert({
					title : "회원가입",
					msg : "닉네임은 영문, 숫자, 한글을 사용해 주세요."
				})
				return;
			}
			var options = {
					params : {
						NICKNM : this.userNickname,
					},
				};
			cf_ajax("/mb/mj/MBMJ0103", options).then(this.nickCheckCB);
		},
		nickCheckCB : function(data) {
			if(data.result === 0) {
				var option = {
        				title : "회원가입",
        	    		msg : "사용 가능한 닉네임이에요. \n 해당 닉네임을 사용하시겠어요?",
        	    		confirmCB : () => {
        	    			$("#nickBtn").attr("disabled",true);
        	    			this.isNotDuplicationNick = true;
        	    			$("#nickBtn").addClass("black");
        	    			$("#nickWrap").removeClass("error");
        	    			} ,
        			};
       			mb_confirm(option);
			} else {
				this.isNotDuplicationNick = false;
				var option = {
			    		title : "회원가입",
			    		msg : "이미 사용중인 닉네임이에요.",
				};
				mb_alert(option);
			}
		},
		
		visionPassword : function(val) {
			if(val === 'new') {
				$('#visionPassword').toggleClass('show');
	            $('#visionPassword').prev('input').attr('type', function(index, attr){
	                return attr == 'text' ? "password" : "text";
	            });	
			} else if (val === 'check') {
				$('#visionPasswordCheck').toggleClass('show');
	            $('#visionPasswordCheck').prev('input').attr('type', function(index, attr){
	                return attr == 'text' ? "password" : "text";
	            });
			}
		},
		
		addAccount : function() {
			if(!this.validateInformation()){
				return;
			}
			var options = {
				params : {
					EMAIL : this.userEmail,
			    	userPassword : this.userPassword,
			    	userPasswordCheck : this.userPasswordCheck,
			    	NICKNM : this.userNickname,
			    	MBR_GNDR : this.userGender,
			    	MBR_BDAY : this.userBirthday.substr(0,4)+this.userBirthday.substr(5,2)+this.userBirthday.substr(8,2),
				},
			};
			cf_ajax("/mb/mj/MBMJ0104", options).then(this.addAccountCB);
		}, 
		addAccountCB : function(data) {
			if(data.result == 'sucess') {
				var option = {
			    		title : "회원가입",
			    		msg : "이메일 인증 및 회원가입이 완료되었어요.\n인증된 이메일로 로그인하세요.",
			    		confirmTxt : "로그인" ,
			    		confirmCB : () => {cf_movePage('/mb/lg/MBLG0100');},
			    }
				mb_alert(option);
			} else {
				var option = {
			    		title : "회원가입",
			    		msg : "처리중 오류가 발생했습니다.\n관리자에게 문의하세요.",
			    }
				mb_alert(option);
			}
		},
		
		setGender : function(gender) {
			if(gender === 'M' && this.userGender !== gender) {
				$("#gender1").parent().addClass('active');
				$("#gender2").parent().removeClass('active');
				this.userGender = gender;
			} else if(gender === 'F' && this.userGender !== gender){
				$("#gender2").parent().addClass('active');
				$("#gender1").parent().removeClass('active');
				this.userGender = gender;
			} else if( this.userGender === gender) {
				$(".radio_btn").removeClass('active');
				$(".radio_btn").removeClass('active');
				this.userGender = '';
			}
		},
		
		setAllCheck: function(check) {
        	if(check === true) {
        		this.checkToS1 = true;
        		this.checkToS2 = true;
        		this.checkToS3 = true;
        	} else if (check === false) {
        		this.checkToS1 = false;
        		this.checkToS2 = false;
        		this.checkToS3 = false;
        	}
        },
        goTC: function(event, type) {
        	this.currentScroll = window.scrollY;
        	event.preventDefault();
        	
        	vueappTcPopup.openTcPopup(type);
			window.scrollTo(0,0);
        },
        confirmClose: function() {
        	var option = {
		    		title : "회원가입",
		    		msg : "회원가입을 그만 하시겠어요?",
		    		confirmCB : () => {mb_goBack()} ,
		    }
			mb_confirm(option);
        },
        
        setBirth: function() {
        	const today = new Date();
			var num = this.userBirthday.replace(/[^0-9]/g, '');
			var fullToday = ''
			if(Number(today.getMonth())+1 < 10 ) {
				if(Number(today.getDate()) < 10 ) {
					fullToday = String(today.getFullYear()) + '0' + String(today.getMonth()+1) + '0' + String(today.getDate());	
				} else {
					fullToday = String(today.getFullYear()) + '0' + String(today.getMonth()+1) + String(today.getDate());
				}
			} else {
				if(Number(today.getDate()) < 10 ) {
					fullToday = String(today.getFullYear()) + String(today.getMonth()+1) + '0' + String(today.getDate());	
				} else {
					fullToday = String(today.getFullYear()) + String(today.getMonth()+1) + String(today.getDate());
				}
			}
			console.log(fullToday)
			if(this.userBirthday.length > 3 ) {
				if(Number(num.substr(0,4)) < 1900 || Number(num.substr(0,4)) > today.getFullYear()) {
					mb_alert({
						title : "회원가입",
						msg : "1900 ~ " + today.getFullYear() + " 사이로 입력해 주세요."
					})
					this.userBirthday = '';
					return;
				} 
			}
			if(num.length === 6 ) {
				if(Number(num.substr(4,2)) < 1 || Number(num.substr(4,2)) > 12) {
					mb_alert({
						title : "회원가입",
						msg : "01 ~ 12 사이로 입력해 주세요."
					})
					this.userBirthday = num.substr(0,4);
					return;
				}
			}
			if(num.length === 8 ) {
				if(Number(num.substr(6,2)) < 1 || Number(num.substr(6,2)) > 31) {
					mb_alert({
						title : "회원가입",
						msg : "01 ~ 31 사이로 입력해 주세요."
					})
					this.userBirthday = num.substr(0,6).replace(/^(\d{4})(\d{2})(\d{2})$/, `$1-$2-$3`);
					return;
				} 
			}
			console.log(fullToday);
			if(num.length === 8 ) {
				if(num > Number(fullToday)) {
					mb_alert({
						title : "회원가입",
						msg : "생년월일은 오늘을 초과할 수 없어요."
					})
					this.userBirthday = num.substr(0,6).replace(/^(\d{4})(\d{2})(\d{2})$/, `$1-$2-$3`);
					return;
				}
			}
			this.userBirthday = num.replace(/^(\d{4})(\d{2})(\d{2})$/, `$1-$2-$3`);
        },
        
        maxCertNum : function() {
        	if(this.userCertificationNumber.length > 6) {
     			this.userCertificationNumber = this.userCertificationNumber.slice(0,6); 
     		}
        }
    },
});
</script>

<jsp:include page="/WEB-INF/jsp/mb/mj/MBMJ0100P01.jsp" flush="true"/>

