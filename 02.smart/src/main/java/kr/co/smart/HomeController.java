package kr.co.smart;

import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;

@Controller
public class HomeController {
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	@RequestMapping("/xml")
	public String test1() {
		
		
		return "ajax/ex/drink";
	}
	
	
	@RequestMapping("/test1")
	public String test(String name, int price, Model model) {
		model.addAttribute("name", name);
		model.addAttribute("price", price);
		return "ajax/ex/test1";
	}
	
	
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Locale locale, Model model, HttpSession session) {
		session.removeAttribute("category");
		return "home";
	}
	
}
