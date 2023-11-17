<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div id="vueapp">
    <template>
	    <div id="container">
	        <div id="content" class="sub_content">
	            <div class="subcriber_wrap">
	                <!-- 차단내역이 없을 경우 -->
	                <div class="no_item" v-if="noBan === true">
	                    <p>차단내역이 없어요.</p>
	                </div>
	                <!-- //차단내역이 없을 경우 -->
	                <div class="item" v-for="(item, index) in dataList">
	                    <div class="thumb">
	                    <img v-if="!cf_isEmpty(item.PF_IMG)" :src="'/common/fileDn?p='+ item.PF_IMG" alt="포토이미지">
	                    <img v-else-if="!cf_isEmpty(item.DEF_IMG)" :src="'/static_resources/images/character' + item.DEF_IMG + '.svg'" alt="포토이미지">
	                    <img v-else src="/static_resources/images/character01.svg" alt="포토이미지">
	                    </div>
	                    <div class="justify">
	                        <span class="nickname">{{item.NICKNM}}</span>
	                        <button type="button" @click="confirmAlert(item.BCK_TGT_ID,item.NICKNM)">차단해제</button>
	                    </div>
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
    mounted : function(){
    	let vh = window.innerHeight * 0.01;
	  	document.documentElement.style.setProperty('--vh', vh + `px`);
    	
       this.getList();
    },
    data : {
    	dataList : [],
		noBan : false,
    },
    methods : {
    	getList : function() {
			var options = {
				params : {},
			} 
			cf_ajax("/mb/sb/MBSB0101", options).then(this.getListCB);
		},
		getListCB : function(data) {
			if(data[0].chkEmpty == 0) {
				vueapp.noBan = true;
				vueapp.dataList = [];
			} else {
				vueapp.dataList = data;	
			}
		},
		
		confirmAlert : function(ID, NICK) {
			var option = {
				title : "확인",
				msg : NICK + " 님을 차단 해제 할까요?",
				confirmTxt : "해제",
				confirmCB : () => {this.delBlock(ID)},
			}
			mb_confirm(option);
		},
		
		delBlock : function(ID) {
			var options = {
				params : {
					BCK_TGT_ID : ID,
				},
			}
			cf_ajax("/mb/sb/MBSB0102", options).then(this.delBlockCB);
		},
		
		delBlockCB : function(data) {
			this.getList();
		} 
		
    },
});
</script>