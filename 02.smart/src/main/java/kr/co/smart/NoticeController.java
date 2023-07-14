package kr.co.smart;

import java.net.URLEncoder;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.multipart.MultipartFile;

import smart.common.CommonUtility;
import smart.common.PageVO;
import smart.member.MemberDAO;
import smart.member.MemberVO;
import smart.notice.NoticeDAO;
import smart.notice.NoticeVO;

@Controller @RequestMapping("/notice")
public class NoticeController {
	@Autowired private NoticeDAO service;
	
	@Autowired private CommonUtility common;
	
	//공지글 답글쓰기 저장처리 요청
	@RequestMapping("/reply_register")
	public String reply(NoticeVO vo, PageVO page
						, MultipartFile file, HttpServletRequest request) throws Exception{
		//화면에서 입력한 답글정보를 DB에 신규저장한 후 응답화면연결- 목록
		if( ! file.isEmpty() ) { //첨부된 파일이 있으면
			vo.setFilename( file.getOriginalFilename() );
			vo.setFilepath( common.fileUpload("notice", file, request) );
		}
		service.notice_reply_regist(vo);
		return "redirect:list"
			+ "?curPage=" + page.getCurPage()
			+ "&search=" + page.getSearch()
			+ "&keyword=" + URLEncoder.encode( page.getKeyword(), "utf-8" ) 
			;
	}
	
	//공지글 답글쓰기 화면 요청
	@RequestMapping("/reply")
	public String reply(int id, PageVO page, Model model) {
		//답글작성시 필요한 원글의 정보를 조회해와
		//답글쓰기 화면에서 사용할 수 있도록 Model에 담는다
		model.addAttribute("vo", service.notice_info(id));
		model.addAttribute("page", page);
		return "notice/reply";
	}
	
	
	
	//공지글 첨부파일 다운로드처리 요청
	@RequestMapping("/download")
	public void download(int id, HttpServletRequest req
								, HttpServletResponse res) throws Exception{
		// 해당 글의 첨부파일 정보를 조회해와 
		// 서버로부터 파일정보를 찾고 클라이언트에 다운로드 처리
		NoticeVO vo = service.notice_info(id);
		common.fileDownload(vo.getFilename(), vo.getFilepath(), req, res);
	}
	
	//공지글정보 수정 저장처리 요청
	@RequestMapping("/update")
	public String update(NoticeVO vo, PageVO page
						, MultipartFile file
						, HttpServletRequest request) throws Exception {
		//원래 첨부되어져 있던 파일정보를 조회해둔다 - 수정전 공지글정보를 조회
		NoticeVO before = service.notice_info(vo.getId());
		
		if( file.isEmpty() ) {
		//첨부파일이 없는 경우: 원래O -> 삭제, 원래O,X -> 그대로
		//원래O 그대로 두는 경우 -> 파일명 이전정보로 담는다
			if( !vo.getFilename().isEmpty() ) {
				vo.setFilename( before.getFilename() );
				vo.setFilepath( before.getFilepath() );
			}
			
		}else {
		//첨부파일이 있는 경우
		//원래O,X -> 첨부파일 업로드
			vo.setFilename( file.getOriginalFilename() );
			vo.setFilepath( common.fileUpload("notice", file, request) );
		}
		
		//화면에서 변경입력한 정보로 DB에 변경저장 한 후 응답화면연결- 정보화면
		if( service.notice_update(vo)== 1 ) {
			//물리적 파일 삭제 처리
			if( file.isEmpty() ) {
				//원래 O -> 화면에서 삭제한 경우
				if( vo.getFilename().isEmpty() ) {
					common.deletedFile(before.getFilepath(), request);
				}
				
			}else {
				// 원래O 바꿔서 첨부한 경우
				common.deletedFile(before.getFilepath(), request);
			}
		}
		
		return "redirect:info?id=" + vo.getId()
				+ "&curPage=" + page.getCurPage()
				+ "&search=" + page.getSearch()
				+ "&keyword=" + URLEncoder.encode( page.getKeyword(), "utf-8" )
				;
		//form태그를 통해 전달된 파라미터와
		//주소에 명시적으로 입력한 파라미터는 다르므로 한글은 인코딩처리를 해야 한다 
	}
	
	//공지글정보 수정 화면 요청
	@RequestMapping("/modify")
	public String modify(int id, Model model, PageVO page) {
		//해당 글의 정보를 DB에서 조회해와 수정화면에 출력할 수 있도록 Model에 담는다
		model.addAttribute("vo", service.notice_info(id));
		model.addAttribute("page", page);
		return "notice/modify";
	}
	
	
	//공지글정보 삭제처리 요청
	@RequestMapping("/delete")
	public String delete(int id, HttpServletRequest request
						, PageVO page) throws Exception{
		//첨부파일이 있는 경우 물리적인 파일을 찾아 삭제할 수 있도록 파일정보를 조회해둔다
		NoticeVO vo= service.notice_info(id);
		
		//해당 공지글을 DB에서 삭제한다. 응답화면 - 목록화면
		if( service.notice_delete(id)== 1 ) {
			common.deletedFile(vo.getFilepath(), request);
		}
		
		return "redirect:list"
				+ "?curPage=" + page.getCurPage()
				+ "&search=" + page.getSearch()
				+ "&keyword=" + URLEncoder.encode( page.getKeyword(), "utf-8" )
				;
	}
	
	
	//공지글정보 화면 요청
	@RequestMapping("/info")
	public String info(int id, Model model, PageVO page) {
		//조회수 증가처리
		service.notice_read(id);
		
		//선택한 공지글 정보를 DB에서 조회해와 화면에 출력할수 있도록 Model에 attribute로 담는다
		model.addAttribute("crlf", "\r\n"); //carriage return line feed
		model.addAttribute("lf", "\n"); 	//line feed
		model.addAttribute("vo", service.notice_info(id));
		model.addAttribute("page", page);
		
		return "notice/info";
	}
	
	//신규 공지글 등록처리 요청
	@RequestMapping("/register")
	public String register(NoticeVO vo, MultipartFile file, HttpServletRequest request) {
		//첨부한 파일이 있는 경우
		if( ! file.isEmpty() ) {
			vo.setFilename( file.getOriginalFilename() );
			vo.setFilepath( common.fileUpload("notice", file, request) );
		}
		//화면에서 입력한 정보로 DB에 신규저장
		service.notice_regist(vo);
		//응답화면연결 - 목록
		return "redirect:list";
	}
	
	
	//신규 공지글 등록 화면 요청
	@RequestMapping("/new")
	public String regist() {
		return "notice/new";
	}
	
	@Autowired private MemberDAO member;
	@Autowired private BCryptPasswordEncoder pw;
	
	//공지글 목록 화면 요청
	@RequestMapping("/list")
	public String list(Model model, HttpSession session, PageVO page) {
		// 임시 로그인처리(테스트후 삭제/주석)---------
		String userid = "admin";
		String userpw = "manager";
		MemberVO login = member.member_info(userid);
		if( pw.matches( userpw, login.getUserpw()) ) {
			session.setAttribute("loginInfo", login);
		}
		//-------------------------------------
		
		
		session.setAttribute("category", "no");
		// DB에서 공지글 목록을 조회해와 목록화면에 출력할 수 있도록
//		List<NoticeVO> list = service.notice_list();
		// Model에 담는다
//		model.addAttribute("list", list);
//		model.addAttribute("list", service.notice_list());
		model.addAttribute("page", service.notice_list(page));
		return "notice/list";
	}

}
