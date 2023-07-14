package smart.customer;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.dao.support.DaoSupport;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Repository;


@Repository
public class CustomerDAO implements CustomerService{
	@Autowired @Qualifier("hanul") private SqlSession sql;
	
	// 생성된 객체(빈으로 등록된 객체들) 의 주소를 스프링 container에 관리가 됨
	// IoC(Inversion of Control) 개발자가 필요할 때마다 new 로 객체를 생성 -> 스프링프레임웤이 객체를 생성
	
	// DI(Dependency Injection) 객체의 주소를 담아주는(주입) 처리
	// 필드에 데이터를 담는 방법 2가지
//	public CustomerDAO(SqlSession sql) {
//		this.sql = sql;
//	}
	
	//executeQuery, executeUpdate
	
	@Override
	public void customer_insert(CustomerVO vo) {
		sql.insert("customer.insert", vo);
	}

	@Override
	public List<CustomerVO> customer_list() {
		return sql.selectList("customer.list");
	}

	@Override
	public CustomerVO customer_info(int id) {
		return sql.selectOne("customer.info", id);
	}

	@Override
	public void customer_update(CustomerVO vo) {
		sql.update("customer.update", vo);
	}

	@Override
	public void customer_delete(int id) {
		sql.delete("customer.delete", id);
	}

	@Override
	public List<CustomerVO> customer_list(String name) {
		return sql.selectList("customer.list", name);
	}

	
	
}
