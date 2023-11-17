package com.pentas.mb.pi.svc;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;

import org.bson.json.JsonObject;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.cmm.dao.CmmnDao;
import com.cmm.utils.common.PentasMap;
import com.cmm.utils.common.PentasMapBuilder;
import com.fasterxml.jackson.databind.annotation.JsonAppend;

@Service
public class MBPI0100Svc {
	
	@Autowired
	CmmnDao cmmnDao;
	
	public PentasMap selectUserInformation(PentasMap params) {
		return cmmnDao.selectOne("com.pentas.mb.pi.MBPI0100.selectUserInformation", params);
	}
	
	public PentasMap selectEmailCheckDuplication(PentasMap params) {
		return cmmnDao.selectOne("com.pentas.mb.pi.MBPI0100.selectEmailCheckDuplicate",params);
	}
	
	public PentasMap selectNickCheckDuplication(PentasMap params) {
		return cmmnDao.selectOne("com.pentas.mb.pi.MBPI0100.selectNickCheckDuplicate",params);
	}
	
	public PentasMap selectEmailCertificationNumber(PentasMap params) {
		return cmmnDao.selectOne("com.pentas.mb.pi.MBPI0100.selectEmailCertificationNumber",params);
	}
	
	public void insertEmailInfomation(PentasMap params) {
		cmmnDao.insert("com.pentas.mb.pi.MBPI0100.insertEmailInfomation", params);
	}
	
	public int updateUserAccount(PentasMap params) {
		return cmmnDao.update("com.pentas.mb.pi.MBPI0100.updateUserAccount", params);
	}
	
	public String getKakaoAccessToken (PentasMap params) {
        String access_Token = "";
        String refresh_Token = "";
        String reqURL = "https://kauth.kakao.com/oauth/token";

        try {
            URL url = new URL(reqURL);
            HttpURLConnection conn = (HttpURLConnection) url.openConnection();

            //POST 요청을 위해 기본값이 false인 setDoOutput을 true로
            conn.setRequestMethod("POST");
            conn.setDoOutput(true);

            //POST 요청에 필요로 요구하는 파라미터 스트림을 통해 전송
            BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(conn.getOutputStream()));
            StringBuilder sb = new StringBuilder();
            sb.append("grant_type=authorization_code");
            sb.append("&client_id=be0febfd13af58fff5aa332543d482a4"); // TODO REST_API_KEY 입력
            sb.append("&redirect_uri=http://192.168.219.179:8080/mb/pi/MBPI0200"); // TODO 인가코드 받은 redirect_uri 입력
            sb.append("&code=" + params.get("code"));
            bw.write(sb.toString());
            bw.flush();

            //결과 코드가 200이라면 성공
            int responseCode = conn.getResponseCode();
            System.out.println("responseCode : " + responseCode);

            //요청을 통해 얻은 JSON타입의 Response 메세지 읽어오기
            BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String line = "";
            String result = "";

            while ((line = br.readLine()) != null) {
                result += line;
            }
            System.out.println("response body : " + result);

            //Gson 라이브러리에 포함된 클래스로 JSON파싱 객체 생성
			JSONParser jp = new JSONParser(); 
			JSONObject jo = (JSONObject) jp.parse(result);  
			access_Token = (String) jo.get("access_token");
			refresh_Token = (String) jo.get("refresh_token");
			 

            System.out.println("access_token : " + access_Token);
            System.out.println("refresh_token : " + refresh_Token);

            br.close();
            bw.close();
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

        return access_Token;
    }
	
	public void createKakaoUser(PentasMap params) {

		String reqURL = "https://kapi.kakao.com/v2/user/me";

	    //access_token을 이용하여 사용자 정보 조회
	    try {
	        URL url = new URL(reqURL);
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();

	        conn.setRequestMethod("POST");
	        conn.setDoOutput(true);
	        conn.setRequestProperty("Authorization", "Bearer " + params.getString("access_Token")); //전송할 header 작성, access_token전송

	        //결과 코드가 200이라면 성공
	        int responseCode = conn.getResponseCode();
	        System.out.println("responseCode : " + responseCode);

  	        //요청을 통해 얻은 JSON타입의 Response 메세지 읽어오기
	        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        String line = "";
	        String result = "";

	        while ((line = br.readLine()) != null) {
	           result += line;
	        }
	        System.out.println("response body : " + result);

	        JSONParser jp = new JSONParser(); 
	        JSONObject jo = (JSONObject) jp.parse(result);

	        String id = jo.get("id").toString();

	        System.out.println("id : " + id);

	        br.close();
	        params.put("SNS_ID", id);
	        params.put("SNS_TYP", "KAKAO");
	        cmmnDao.update("com.pentas.mb.pi.MBPI0100.updateUserSocialInfo", params);
       	} catch (IOException e) {
            e.printStackTrace();
       	} catch (ParseException e) {
       		// TODO Auto-generated catch block
       		e.printStackTrace();
		}
	}
	
	public PentasMap kakaoLogout(PentasMap params) {
	    String reqURL = "https://kapi.kakao.com/v1/user/logout";
	    try {
	        URL url = new URL(reqURL);
	        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
	        conn.setRequestMethod("POST");
	        conn.setRequestProperty("Authorization", "Bearer " + params.getString("access_Token"));
	        System.out.println("엑세스코드 : "+params.getString("access_Token"));
	        int responseCode = conn.getResponseCode();
	        System.out.println("responseCode : " + responseCode);
	        if(responseCode == 401) {
	        	return new PentasMapBuilder().put("result", "noLogin").build();
	        }
	        
	        BufferedReader br = new BufferedReader(new InputStreamReader(conn.getInputStream()));
	        
	        String result = "";
	        String line = "";
	        
	        while ((line = br.readLine()) != null) {
	            result += line;
	        }
	        System.out.println(result);
	        params.put("SNS_ID", null);
	        params.put("SNS_TYP", null);
	        params.put("SNS_DTM", null);
	        cmmnDao.update("com.pentas.mb.pi.MBPI0100.updateUserSocialReset", params);
	        return new PentasMapBuilder().put("result", "success").build();
	    } catch (IOException e) {
	        // TODO Auto-generated catch block
	        e.printStackTrace();
	        return new PentasMapBuilder().put("result", "fail").build();
	    }
	}
}
