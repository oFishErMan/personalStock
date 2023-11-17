<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="vueapp">
	<template>
		<div id="container">
        <div id="content" class="sub_content">
            <div class="my_info_wrap">
                <div class="my_info">
                    <div class="photo_area">
                        <!-- 랜덤뽑기 하면 기본이미지 변경으로 클래스가 추가 -->
                        <div class="photo random1">
                        	<img v-if="!cf_isEmpty(previewProfileImage)" :src="previewProfileImage" alt="프로필 사진">
                        	<img v-else-if="!cf_isEmpty(def_img)" :src="'/static_resources/images/character' + def_img + '.svg'" alt="기본 이미지">
	                		<img v-else src="/static_resources/images/character01.svg" alt="기본 이미지">
                        </div>
                        <input type="file" id="fileAttcher" @change="checkFile(event);" accept="image/*" hidden/>
                        <button type="button" class="btn_profile" @click="uploadFile();"><span class="blind">프로필 설정</span></button>
                    </div>
                    <div class="my_info__text">
                        <span class="my_nickname" v-text="userNick"></span>
                    </div>
                </div>

                <div class="random_draw">
                    <button type="button" @click="getRandomProfileImage">
                        <strong>기본 이미지 랜덤 뽑기!</strong>
                        <span>우측 포켓을 눌러 뽑아보세요 👉🏻</span>
                    </button>
                </div>
                <form action="">
                    <div class="item_area mgTop40">
                        <span class="title essential">닉네임</span>
                        <div class="input_wrap input_button">
                            <div class="input_inner">
                                <input type="text"  v-model="userNickChange" placeholder="닉네임을 입력해 주세요.">
                                <button type="button" class="btn_delete" id="userNicknameBtn" @click="userNickChange = ''"><span class="blind">삭제</span></button>
                            </div>
                            <button type="button" class="btn_duplication black" v-if="!onFocusNick">중복확인</button>
                            <button type="button" class="btn_duplication black" v-else-if="isChangeNick">중복확인</button>
                            <button type="button" class="btn_duplication" @click="nickCheck" v-else>중복확인</button>
                        </div>
                        <div class="message">영문/숫자/한글을 조합하여 2~6자로 입력해 주세요.</div>
                        <div class="message">닉네임은 30일에 한번씩 변경 가능해요.</div>
                    </div>
                    
                    <div class="item_area mgTop40">
                        <span class="title essential">이메일</span>
                        <div class="input_wrap input_button">
                            <div class="input_inner ">
                                <input type="text" id="userEmail" v-model="userEmailChange" placeholder="이메일을 입력해 주세요.">
                                <button type="button" class="btn_delete" @click="userEmailChange = ''"><span class="blind">삭제</span></button>
                            </div>
                            <button type="button" class="btn_duplication black" id="reSendBtn" v-if="isCertification">인증완료</button>
		                    <button type="button" class="btn_duplication" id="reSendBtn" v-else-if="isSendEmail" @click="sendEmail">재전송</button>
		                    <button type="button" class="btn_duplication black" id="sendBtn" v-else-if="!onFocusEmail">인증요청</button>
		                    <button type="button" class="btn_duplication" id="sendBtn" v-else @click="sendEmail">인증요청</button>
                        </div>
                        <div class="message">가입된 이메일을 변경할 수 있어요. 새로 사용하실 이메일을 입력 후 [인증요청] 버튼을 눌러주세요.</div>
                    </div>
                    
                    <div class="item_area mgTop40 userCertificationNumberDiv">
                        <span class="title essential">인증번호</span>
                        <div class="input_wrap input_type2"> 
                            <div class="input_inner">
                                <input type="number" id="userCertificationNumber" v-model="userCertificationNumber" placeholder="6자리를 입력해 주세요." @input="maxCertNum">
                                <button type="button" class="btn_delete" @click="userCertificationNumber = ''"><span class="blind">삭제</span></button>
                            </div>
                            <button type="button" class="btn_duplication black" v-if="isCertification">확인</button>
                            <button type="button" class="btn_duplication" @click="certificationNumberCheck" v-else>확인</button>
                        </div>
                    </div>
					
					<div class="item_area mgTop40">
                        <span class="title">성별</span>
                        <div class="input_wrap input_both">
                            <div class="radio_btn"><input type="radio" name="sex" id="sex1" @click="setGender('M')"><label for="sex1">남</label></div>
                            <div class="radio_btn"><input type="radio" name="sex" id="sex2" @click="setGender('F')"><label for="sex2">여</label></div>
                        </div>
                    </div>

                    <div class="item_area mgTop40">
                        <span class="title">생년월일</span>
                        <div class="input_wrap">
                            <div class="input_inner">
                                <input type="text" maxlength="10" @keyup="setBirth()" v-model="userBirthdayChange" id="openDtmPicker" placeholder="ex. 19800101">
                                <button type="button" class="btn_delete" @click="userBirthdayChange = ''"><span class="blind">삭제</span></button>
                            </div>
                            <div class="message">생년월일은 8자리의 숫자로 입력해 주세요.</div>
                        </div>
                    </div>
					
                    <div class="item_area mgTop40">
                        <span class="title mgBottom0">소셜 로그인 설정</span>
                        <ul class="sns_list">
                            <li class="kakao" v-if="kakao == false && isSocial == false ">
                                <span>카카오 소셜 로그인</span>
                                <button type="button" @click="loginWithKakao">연결하기</button>
                            </li>
                            <li class="kakao" v-else-if="kakao == true">
                                <span>카카오 로그인 사용중</span>
                                <button type="button" class="on" @click="kakaoLogout">연결해제</button>
                            </li>
                            
                            <li class="naver" v-if="naver == false && isSocial == false ">
                                <span>네이버 소셜 로그인</span>
                                <button type="button">연결하기</button>
                            </li>
                            <li class="naver" v-if="naver == true">
                                <span v-text="userSocialEmail"></span>
                                <button type="button" class="on">연결해제</button>
                            </li>
                            
                            <li class="googel" v-if="google == false && isSocial == false ">
                                <span>구글 소셜 로그인</span>
                                <button type="button">연결하기</button>
                            </li>
                            <li class="googel" v-if="google == true">
                                <span v-text="userSocialEmail"></span>
                                <button type="button" class="on">연결해제</button>
                            </li>
                            
                            <li class="apple" v-if="apple == false && isSocial == false ">
                                <span >애플 소셜 로그인</span>
                                <button type="button">연결하기</button>
                            </li>
                            <li class="apple" v-if="apple == true">
                                <span v-text=userSocialEmail></span>
                                <button type="button" class="on">연결해제</button>
                            </li>
                        </ul>
                        <div class="message"><br>소셜 로그인은 한가지 서비스만 연결이 가능해요.</div>
                    </div>
                    <button type="button" class="btn_withdrawn" @click="goWithdrawal()">회원 탈퇴</button>
                    <div class="btn_wrap">
                        <button type="button" class="btn btn--big" @click="updateAccount" :disabled="btnDisable"><span>수정하기</span></button>
                    </div>
                </form>
            </div>
        </div>
    </div>
	</template>
</div>
</div>
<jsp:include page="/WEB-INF/jsp/mb/pi/MBPI0100P01.jsp"/>
<script src="https://t1.kakaocdn.net/kakao_js_sdk/2.4.0/kakao.min.js" integrity="sha384-mXVrIX2T/Kszp6Z0aEWaA8Nm7J6/ZeWXbL8UpGRjKwWe56Srd/iyNmWMBhcItAjH" crossorigin="anonymous"></script>
<script>
var vueapp = new Vue({
    el : "#vueapp",
    watch : {
    	// 각 기능 및 수정 버튼 활성화 실시간 Validation [s]
    	userNickChange : function (value) {
    		if(this.userNick === value
    				&& !this.isCertification
    				&& !this.isGenderChange
    				&& !this.isBirthdayChange) {
    			this.btnDisable = true;
    		}
    		this.isChangeNick = false;
    		this.onFocusNick = true;
    	},
    	
    	userEmailChange : function (value) {
    		if(this.userEmail === value
    				&& !this.isChangeNick
    				&& !this.isGenderChange
    				&& !this.isBirthdayChange) {
    			this.btnDisable = true;
    		}
   			this.isSendEmail = false;
   			this.onFocusEmail = true;
    	},
    	
    	userGenderChange : function (value) {
    		if(value === this.userGender
    				&& !this.isChangeNick
    				&& !this.isCertification
    				&& !this.isBirthdayChange) {
    			this.btnDisable = true;
    		}
    		if(value === this.userGender) {
    			this.isGenderChange = false;
    		} else {
    			this.isGenderChange = true;
    		}
    	},
    	
    	userBirthdayChange : function (value) {
    		var reg = /[^0123456789-]/g;
    		if(event.keyCode != 8) {
	    		if(reg.test(value)) {
	    			if(this.userBirthdayChange.length !== 1) {
		    			this.userBirthdayChange = this.userBirthdayChange.substr(0,this.userBirthdayChange.length-1);
	    			} else {
	    				this.userBirthdayChange = '';
	    			}
	    			mb_alert({
	    				title : "내정보 수정",
	    				msg : "생년월일은 숫자만 사용 가능해요."
	    			})
	    		}
    		}
    		if(value === this.userBirthday
    				&& !this.isChangeNick
    				&& !this.isCertification
    				&& !this.isGenderChange) {
    			this.btnDisable = true;
    		} else {
    			this.btnDisable = false;
    		}
    		const dateDateValue = Date.parse(value);
    		const today = new Date();
    		/* // 생일 실시간 validation
    		if (dateDateValue > today) {
    			mb_alert({
					title : "내정보 수정",
					msg : "생일은 현재 날짜를 초과할 수 없습니다."
    			})
    			if(Number(today.getMonth())+1 < 10 ) {
    	        	this.userBirthdayChange = today.getFullYear() + '-' + '0' + (today.getMonth()+1) + '-' + today.getDate();
    	        } else {
    		        this.userBirthdayChange = today.getFullYear() + '-' + (today.getMonth()+1) + '-' + today.getDate();
    	        }
    		} */
    		if(value === this.userBirthday) {
    			this.isBirthdayChange = false;
    		} else {
    			this.isBirthdayChange = true;
    		}
    				
    	}
    	// 각 기능 및 수정 버튼 활성화 실시간 validation [e]
    },
    mounted : function() {
    	$('.userCertificationNumberDiv').hide();
    	this.getUserInfo();
    	//카카오 로그인 API 실행
    	Kakao.init('76232c659fc262f2eab8a48d25b8ff6d');
    	Kakao.isInitialized();
    	console.log(Kakao.isInitialized());
    	if('${SNS_TYP}' === 'KAKAO') {
    		mb_alert({
    			title : '내정보 수정',
    			msg : '카카오 소셜 로그인이 연결되었어요.'
    		});
    	}
    },
    data : {
    	userNick : '', // 기존 닉네임
    	userNickChange : '', // 변경 할 닉네임
    	userNickChangeCheck : '', // 중복체크 후 닉네임 저장
    	isChangeNick : false, // 중복체크 확인
    	onFocusNick : false,
    	userEmail : '', // 기존 이메일
    	userEmailChange : '', // 변경 할 이메일
    	userEmailChangeCheck : '', // 인증번호 확인 후 이메일 저장
    	isSendEmail : false, // 이메일 전송 확인
    	onFocusEmail : false,
    	userCertificationNumber : '', // 이메일 확인번호
    	isCertification : false, // 이메일 확인번호 확인
    	userGender : '', // 기존 성별
    	userGenderChange : '', // 변경 할 성별
    	isGenderChange : false, // 성별 변경 확인
    	userBirthday : '', // 기존 생일
    	userBirthdayChange : '', // 변경 할 생일
    	isBirthdayChange : false, // 생일 변경 확인
    	nickUpdateDate : '', // 닉네임 변경 일자
    	nickUpdateDateChange : '', // 닉네임 변경 일자
    	btnDisable : true, // 버튼 활성화
    	kakao : false,
    	naver : false,
    	google : false,
    	apple : false,
    	userSocialCode : '',
    	userSocialEmail : '', 
    	isSocial : false,
    	profileImage : {},
    	previewProfileImage: '',
    	def_img : '',
    	currentScroll : 0, //회원탈퇴화면 이동 시 저장한 스크롤 위치
    },
    methods : {
    	// 내 정보 가져오기
    	getUserInfo : function() {
    		var options = {
					params : {},
				};
			cf_ajax("/mb/pi/MBPI0101", options).then(this.getUserInfoCB);
    	},
    	getUserInfoCB : function(data) {
    		this.userGender = data.MBR_GNDR;
    		this.userGenderChange = data.MBR_GNDR;
    		if(data.MBR_GNDR === 'M') {
    			$('#sex1').parent().addClass('active').siblings().removeClass('active');
    		} else if (data.MBR_GNDR === 'F') {
    			$('#sex2').parent().addClass('active').siblings().removeClass('active');
    		}
    		if(data.MBR_BDAY.length === 8) {
	    		this.userBirthday = data.MBR_BDAY.substr(0,4)+'-'+data.MBR_BDAY.substr(4,2)+'-'+data.MBR_BDAY.substr(6,2);
	    		this.userBirthdayChange = data.MBR_BDAY.substr(0,4)+'-'+data.MBR_BDAY.substr(4,2)+'-'+data.MBR_BDAY.substr(6,2);
    		}
    		if(data.SNS_TYP === "KAKAO") {
    			this.kakao = true;
    			this.isSocial = true;
    		} else if(data.SNS_TYP === "NAVER") {
    			this.naver = true;
    			this.isSocial = true;
    		} else if(data.SNS_TYP === "GOOGLE") {
    			this.google = true;
    			this.isSocial = true;
    		} else if(data.SNS_TYP === "APPLE") {
    			this.apple = true;
    			this.isSocial = true;
    		}
    		
    		this.nickUpdateDate = data.NICKNM_UPD_DTM;
    		this.userNick = data.NICKNM;
    		this.userNickChange = data.NICKNM;
    		this.userEmail = data.EMAIL;
    		this.userEmailChange = data.EMAIL;
    		this.pf_img = data.PF_IMG;
    		this.def_img = data.DEF_IMG;
    		this.previewProfileImage = !cf_isEmpty(data.PF_IMG) ? "/common/fileDn?p=" + data.PF_IMG : "";
    		this.$nextTick(function() { 
	    		this.onFocusNick = false;
	    		this.onFocusEmail = false;
   		    }); 
    		/* !cf_isEmpty(data.DEF_IMG) ? $('.my_info .photo_area').css('background', 'url("/static_resources/images/character' + this.def_img + '.svg") no-repeat') : ''; */
    	},
    	
    	// 닉네임 중복체크
		nickCheck : function() {
			/* const dateValue = Date.parse(Number(this.nickUpdateDate.substr(0,4)),Number(this.nickUpdateDate.substr(4,2)),Number(this.nickUpdateDate.substr(6,2))); */
			// 닉네임 변경 일자 계산 [s]
			const dateValue = new Date(this.nickUpdateDate.substr(0,4) + '-' + this.nickUpdateDate.substr(4,2) + '-' + this.nickUpdateDate.substr(6,2));
    		const today = new Date();
    		const todayValue = Date.parse(today);
    		const remainDate = Math.floor((todayValue-dateValue)/(1000*60*60*24));
    		if(remainDate < 30) {
    			mb_alert({
    				title : "내정보 수정",
    				msg : String(30-remainDate)+ "일 이후에 닉네임을 변경할 수 있어요." 
    			})
    			return;
    		}
    		// 닉네임 변경 일자 계산 [e]
			if(this.userNickChange.length < 2 || this.userNickChange.length > 6) {
				var option = {
			    		title : "내정보 수정",
			    		msg : "닉네임을 2~6자로 입력해 주세요.",
				};
				mb_alert(option);
				return;
			}
			const regex = /^[ㄱ-ㅎ|가-힣|a-z|A-Z|0-9|]+$/;
			if(!regex.test(this.userNickChange)) {
				mb_alert({
					title : "회원가입",
					msg : "닉네임은 영문, 숫자, 한글을 사용해 주세요."
				})
				return;
			}
			var blank_pattern = /[\s]/g;
			if(blank_pattern.test(this.userNickChange)){
				mb_alert({
					title : "회원가입",
					msg : "닉네임은 영문, 숫자, 한글을 사용해 주세요."
				})
				return;
			}
			if(this.userNickChange === this.userNick) {
				var option = {
			    		title : "내정보 수정",
			    		msg : "현재 사용중인 닉네임이에요.",
				};
				mb_alert(option);
				return;
			}
			var options = {
					params : {
						NICKNM : this.userNickChange,
					},
				};
			cf_ajax("/mb/pi/MBPI0102", options).then(this.nickCheckCB);
		},
		nickCheckCB : function(data) {
			if(data.result === 0) {
				var option = {
        				title : "내정보 수정",
        	    		msg : "사용 가능한 닉네임이에요. \n 해당 닉네임을 사용할까요?",
        	    		confirmCB : () => {this.isChangeNick = true;this.btnDisable = false;this.userNickChangeCheck = this.userNickChange} ,
        			};
       			mb_confirm(option);
			} else {
				var option = {
			    		title : "내정보 수정",
			    		msg : "현재 사용중인 닉네임이에요.",
				};
				mb_alert(option);
			}
		},

    	// 이메일 인증번호 전송
    	sendEmail : function() {
			var emailRegex = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
			if (!emailRegex.test(this.userEmailChange)) {
				var option = {
			    		title : "내정보 수정",
			    		msg : "이메일을 형식에 맞춰 적어주세요.",
				};
				mb_alert(option);
				return;
			} else {
				var options = {
						params : {
							email : this.userEmailChange,
							
						},
					};
				cf_ajax("/mb/pi/MBPI0103", options).then(this.sendEmailCB);
			}
		},
		sendEmailCB : function(data) {
			if(data.result === 'duplicated') {
				var option = {
			    		title : "내정보 수정",
			    		msg : "사용중인 이메일이에요. \n이메일을 다시 입력해 주세요.",
				};
				mb_alert(option);
			} else if(data.result === 'sucess') {
				this.isCertification = false;
				this.isSendEmail = true;
				var option = {
			    		title : "내정보 수정",
			    		msg : "이메일을 전송했어요.",
				};
				mb_alert(option);
				$('.userCertificationNumberDiv').show();
			}
		},
		
		//이메일 확인번호 확인
		certificationNumberCheck : function() {
			var options = {
					params : {
						EMAIL : this.userEmailChange,
						EMAIL_CRT_NO : this.userCertificationNumber,
					},
				};
			cf_ajax("/mb/pi/MBPI0104", options).then(this.certificationNumberCheckCB);
		},
		certificationNumberCheckCB : function(data) {
			if(data.result === 1) {
				this.isCertification = true;
				this.btnDisable = false;
				this.userEmailChangeCheck = this.userEmailChange;
				var option = {
			    		title : "내정보 수정",
			    		msg : "인증이 완료되었어요.",
				};
				$('#userCertificationNumber').attr('disabled', true);
				$('#userEmail').attr('disabled', true);
				mb_alert(option);
			} else {
				var option = {
			    		title : "내정보 수정",
			    		msg : "올바르지 않은 인증번호예요. \n다시 입력해 주세요. ",
				};
				mb_alert(option);
			}
			
		},
    	
		// 최종 수정 전 2차 검증
		validateInformation : function() {
			var emailRegex = /^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$/g;
			var option = {};
			
			if (!emailRegex.test(this.userEmailChangeCheck) && this.isCertification) {
				option = {
			    		title : "내정보 수정",
			    		msg : "이메일을 형식에 맞춰 적어주세요.",
				};
				mb_alert(option);
				return false;
			}
			if(this.isChangeNick) {
				if (this.userNickChangeCheck.length < 2 || this.userNickChangeCheck.length > 6 ) {
					option = {
				    		title : "내정보 수정",
				    		msg : "닉네임은 2~6자로 입력해 주세요.",
					};
					mb_alert(option);
					return false;
				}	
			}
			
			if(this.isSendEmail && !this.isCertification) {
				option = {
			    		title : "내정보 수정",
			    		msg : "이메일 인증번호를 확인해 주세요.",
				};
				mb_alert(option);
				return false;
			}
			
			if(this.isChangeNick) {
				if(this.userNickChange !== this.userNickChangeCheck || this.userNickChange === this.userNick) {
					mb_alert({title : "내정보 수정", msg : "닉네임 중복확인을 해주세요."})
					return false;
				}
			}
			
			if(!this.isChangeNick) {
				if(this.userNickChange !== this.userNick) {
					mb_alert({title : "내정보 수정", msg : "닉네임 중복확인을 해주세요."})
					return false;
				}
			}
			
			if(!this.isSendEmail) {
				if(this.userEmailChange !== this.userEmail) {
					mb_alert({title : "내정보 수정", msg : "이메일 인증을 해주세요."})
					return false;
				}
			}
			
			return true;
		},
		
		// 내 정보 수정
		updateAccount : function() {
			var today = new Date();
			var todayStr = '';
			if(Number(today.getMonth())+1 < 10 ) {
				if(Number(today.getDate()) < 10 ) {
					todayStr = today.getFullYear() + '0' + (today.getMonth()+1) + '0' + today.getDate() + today.getHours() + today.getMinutes() + today.getSeconds();	
				} else {
					todayStr = today.getFullYear() + '0' + (today.getMonth()+1) + today.getDate() + today.getHours() + today.getMinutes() + today.getSeconds();
				}
			} else {
				if(Number(today.getDate()) < 10 ) {
					todayStr = today.getFullYear() + (today.getMonth()+1) + '0' + today.getDate() + today.getHours() + today.getMinutes() + today.getSeconds();	
				} else {
					todayStr = today.getFullYear() + (today.getMonth()+1) + today.getDate() + today.getHours() + today.getMinutes() + today.getSeconds();
				}
			}
			
			
			if(!this.validateInformation()){
				return;
			}
			var options = {
				fileList: [this.profileImage],
				params : {
					EMAIL : this.isCertification ? this.userEmailChangeCheck : this.userEmail,
			    	NICKNM : this.isChangeNick ? this.userNickChangeCheck : this.userNick,
			    	MBR_GNDR : this.userGenderChange,
			    	MBR_BDAY : this.userBirthdayChange.substr(0,4)+this.userBirthdayChange.substr(5,2)+this.userBirthdayChange.substr(8,2),
			    	NICKNM_UPD_DTM : this.isChangeNick ? todayStr : this.nickUpdateDate,
			    	PF_IMG : this.pf_img, 
			    	DEF_IMG : this.def_img,
				},
			};
			cf_ajax("/mb/pi/MBPI0105", options).then(this.updateAccountCB);
		}, 
		updateAccountCB : function(data) {
			if(data.result == 'sucess') {
				var option = {
			    		title : "내정보 수정",
			    		msg : "정보수정이 완료되었어요.",
			    		confirmCB : () => {location.reload()},
			    }
				mb_alert(option);
			} else {
				var option = {
			    		title : "내정보 수정",
			    		msg : "처리중 오류가 발생했습니다.\n관리자에게 문의하세요.",
			    }
				mb_alert(option);
			}
		},
		
		// 성별 변경 버튼 액션
		setGender : function(gender) {
			if(gender === 'M' && this.userGenderChange !== gender) {
				$("#sex1").parent().addClass('active');
				$("#sex2").parent().removeClass('active');
				this.userGenderChange = gender;
			} else if(gender === 'F' && this.userGenderChange !== gender){
				$("#sex2").parent().addClass('active');
				$("#sex1").parent().removeClass('active');
				this.userGenderChange = gender;
			} else if( this.userGenderChange === gender) {
				$(".radio_btn").removeClass('active');
				this.userGenderChange = '';
			}
			this.btnDisable = false;
		},
		
		uploadFile : function() {
			$("#fileAttcher").click();
		},
		
		//프로필 이미지 검증
		checkFile: function(event) {
 			if (event.target.files.length < 1)
 				return;
			
 			// 기본 이미지는 없앰.
 			this.def_img = '';
 			
 			this.profileImage = event.target.files[0];
 			// profile 이미지도 용량 체크 해야하나?
// 			if (file.size > 1024 * 1024 * 20) {
// 		    	option.msg = '파일은 용량은 20MB 이하만 가능합니다.';
// 		    	return;
// 		    }
		    
            var reader = new FileReader();
            reader.onload = (e) => {
            	this.previewProfileImage = e.target.result;
            };
            reader.readAsDataURL(this.profileImage);
            event.target.value = '';
            /* $('.my_info .photo_area').css('background', 'url("") no-repeat'); */
            this.btnDisable = false;
		},
		getRandomProfileImage : function() {
			this.btnDisable = false;
			var newNum = 0;
			this.pf_img = '';
			this.profileImage = {};  // 선택한 이미지 파일 정보가 있으면 비워줌.
			
			// 같은 이미지가 두번 나오는걸 방지.
			while(1) {
				newNum = Math.floor(Math.random() * 5 + 1);
				if ("0" + newNum != this.def_img)			
					break;
			}
			
			this.def_img = "0" + newNum;
			this.previewProfileImage = null;//'/static_resources/images/character' + this.def_img + '.svg';
			/* $('.my_info .photo_area').css('background', 'url("/static_resources/images/character' + this.def_img + '.svg") no-repeat'); */
		},
		
		// 회원탈퇴 페이지 이동
		goWithdrawal : function() {
			this.currentScroll = window.scrollY;
			if ($('.withdrawal').is(':visible')) {
				$('.withdrawal').hide();
				$('#wrap').show();
			} else {
				withdrawVueapp.reason = [];
				withdrawVueapp.etcCount = 0;
				withdrawVueapp.etcText = "";
				withdrawVueapp.etcCheck = false;
				withdrawVueapp.password = "";
				withdrawVueapp.checkPassword = false;
				withdrawVueapp.btnDisable = true;
				$('.withdrawal').show();
				$('#wrap').hide();
			}
			window.scrollTo(0,0);
		},
		
		removeValue : function(val) {
			if(val === 'NICK') {
				this.userNickChange = '';
			} else if (val === 'EMAIL') {
				this.userEmailChange = '';
			} else if (val === 'CERT') {
				this.userCertificationNumber = '';
			}
		},
		
		//생일 실시간 검증
		setBirth: function() {
			const today = new Date();
			var num = this.userBirthdayChange.replace(/[^0-9]/g, '');
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
			
			
			if(this.userBirthdayChange.length > 3 ) {
				if(Number(num.substr(0,4)) < 1900 || Number(num.substr(0,4)) > today.getFullYear()) {
					mb_alert({
						title : "내정보 수정",
						msg : "1900 ~ " + today.getFullYear() + " 사이로 입력해 주세요."
					})
					this.userBirthdayChange = '';
					return;
				} 
			}
			if(num.length === 6 ) {
				if(Number(num.substr(4,2)) < 1 || Number(num.substr(4,2)) > 12) {
					mb_alert({
						title : "내정보 수정",
						msg : "01 ~ 12 사이로 입력해 주세요."
					})
					this.userBirthdayChange = num.substr(0,4);
					return;
				}
			}
			if(num.length === 8 ) {
				if(Number(num.substr(6,2)) < 1 || Number(num.substr(6,2)) > 31) {
					mb_alert({
						title : "내정보 수정",
						msg : "01 ~ 31 사이로 입력해 주세요."
					})
					this.userBirthdayChange = num.substr(0,6).replace(/^(\d{4})(\d{2})(\d{2})$/, `$1-$2-$3`);
					return;
				} 
			}
			if(num.length === 8 ) {
				if(num > Number(fullToday)) {
					mb_alert({
						title : "내정보 수정",
						msg : "생년월일은 오늘을 초과할 수 없어요."
					})
					this.userBirthdayChange = num.substr(0,6).replace(/^(\d{4})(\d{2})(\d{2})$/, `$1-$2-$3`);
					return;
				}
			}
			this.userBirthdayChange = num.replace(/^(\d{4})(\d{2})(\d{2})$/, `$1-$2-$3`);
        },
        maxCertNum : function() {
        	if(this.userCertificationNumber.length > 6) {
     			this.userCertificationNumber = this.userCertificationNumber.slice(0,6); 
     		}
        },
        loginWithKakao : function() {
        	Kakao.Auth.authorize({
        	      redirectUri: 'http://192.168.219.179:8080/mb/pi/MBPI0200',
        	    });
        	
        },
        kakaoLogout : function() {
        	var options = {
    				params : {
    				},
    			};
        	cf_ajax("/mb/pi/MBPI0201", options).then(this.kakaoLogoutCB);
        },
        kakaoLogoutCB : function(data) {
        	if(data.result === "success") {
        		mb_alert({
    				title : "내정보 수정",
    				msg : "카카오 로그아웃이 완료되었어요.",
    				confirmCB : () => {location.reload();}
    			})	
        	}
        	
        	if(data.result === "fail") {
        		mb_alert({
    				title : "내정보 수정",
    				msg : "처리중 오류가 발생했어요.\n관리자에게 문의해 주세요.",
    				confirmCB : () => {location.reload();}
    			})	
        	}
        	
        	if(data.result === "noLogin") {
        		mb_alert({
    				title : "내정보 수정",
    				msg : "카카오 로그인 연결해제를 위해서는\n로그인 시 카카오 로그인을 사용해 주세요.",
    				confirmCB : () => {location.reload();}
    			})	
        	}
        	
        },
    },
});
</script>
<script>
$(function() {
	//기본 공기알 뽑기 이벤트
    const animateCSS = (element, animation, prefix = 'animate__') =>
        // We create a Promise and return it
        new Promise((resolve, reject) => {
            const animationName = prefix+animation;
            const node = document.querySelector(element);

            node.classList.add(prefix+'animated', animationName);

            // When the animation ends, we clean the classes and resolve the Promise
            function handleAnimationEnd(event) {
                event.stopPropagation();
                node.classList.remove(prefix+'animated', animationName);
                resolve('Animation ended');
            }

            node.addEventListener('animationend', handleAnimationEnd, {once: true});
        });

    document.querySelector('.random_draw').addEventListener('click',function(){
        animateCSS('.random_draw', 'bounce');
        setTimeout(function(){
            document.querySelector('.random_draw').classList.remove('animate__animated');
            document.querySelector('.random_draw').classList.remove('animate__bounce');
        },1000);
    })
});
</script>
