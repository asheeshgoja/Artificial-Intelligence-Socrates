import jess.JessException;
import jess.Rete;

public class Socrates_AsJavaApp {
	public static void main(String[] args) {
		try {
			Rete env = new Rete();
			env.batch("..\\SocratesKnowledgeBase.clp");
			env.reset();
			env.run();
		} catch (JessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}
}
