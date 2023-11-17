<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="tcPopup">
	<template>
		<div class="full_popup">
		    <div class="full_popup__header">
		        <h2 class="title">{{title}}</h2>
		        <button type="button" class="popup_close" @click="clickCloseBtn"><span class="blind">팝업닫기</span></button>
		    </div>
		    <div class="full_popup__body">
		        <div class="terms" v-html="term"></div>
		        <div class="btn_wrap fixed">
		            <button type="button" class="btn btn--big" @click="clickCloseBtn();clickConfrim();"><span>확인했어요</span></button>
		        </div>
		    </div>
		</div>
	
	</template>
</div>

<script>
var vueappTcPopup = new Vue({
	el : "#tcPopup",
	mounted : function() {
		$("#tcPopup").hide();
	},
	/*
	term - DB 에서 불러온 약관 내용
	*/
	data : {
		type: "",
		title: "",
		term: "",
	},
	methods: {
		/*
		회원가입 화면에서 '서비스 이용약관' 팝업을 띄울 경우 호출.
		*/
		openTcPopup: function(type) {
			this.type = type;
			
			if (type == "USE")
				this.title = "서비스 이용약관";
			else if (type == "PRIV")
				this.title = "개인정보 수집 및 이용동의";
			else if (type == "MKT")
				this.title = "개인정보 마케팅 활용동의";
			this.getTC();
		},
		/*
		DB 에서 이용약관 조회
		*/
		getTC: function() {
    		var options = {
				params : {
					type: this.type
				},
			}
    		
    		
			cf_ajax("/mb/mj/MBMJ0100P01/MBMJ0100P0101", options).then(this.getTCCB);
		},
		/*
		조회한 이용약관 내용을 화면에 보여줌.
		*/
		getTCCB: function(data) {
			if (data.tnc_cont == null)
				this.term = "내용을 준비중이에요.";
			else
				this.term = data.tnc_cont;
			// 데이터를 조회 해 오고 나서 show 하고 회원가입화면은 hide.
			$("#tcPopup").show();
			$("#vueapp").hide();
		},
		/*
		'X' 버튼이나 '확인했어요' 버튼을 클릭해서 창을 닫을 경우.
		*/
		clickCloseBtn : function() {
			$("#tcPopup").hide();
			$("#vueapp").show();
			window.scrollTo(0,vueapp.currentScroll);
		},
		
		clickConfrim : function() {
			if (this.type == "USE")
				vueapp.checkToS1 = true;
			else if (this.type == "PRIV")
				vueapp.checkToS2 = true;
			else if (this.type == "MKT")
				vueapp.checkToS3 = true;
		}
	}
});
</script>

