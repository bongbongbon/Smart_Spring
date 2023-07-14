package smart.notice;

import java.util.List;

import smart.common.PageVO;

public interface NoticeService {
	// CRUD
	int notice_regist(NoticeVO vo); 	// 공지글 신규 저장
	int notice_reply_regist(NoticeVO vo); 	// 공지글 답글 신규 저장
	List<NoticeVO> notice_list(); 		// 공지글목록 조회
	PageVO notice_list(PageVO page); 		// 해당 페이지의 공지글목록 조회
	NoticeVO notice_info(int id); 		// 공지글정보 조회
	int notice_update(NoticeVO vo); 	// 공지글정보 수정 저장
	int notice_read(int id); 			// 공지글정보 조회수 증가처리
	int notice_delete(int id);			// 공지글 삭제
}
