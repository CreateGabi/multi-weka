package base;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Enumeration;
import java.util.Random;
import java.util.Scanner;

import weka.classifiers.Classifier;
import weka.classifiers.Evaluation;
import weka.classifiers.trees.RandomForest;
import weka.core.Attribute;
import weka.core.DenseInstance;
import weka.core.Instances;
import weka.core.SerializationHelper;
import weka.core.converters.CSVLoader;

public class WekaTest_titanic_4 {

	public static void main(String[] args) throws Exception {
		// 1. 데이터 로딩(수집)
//		Instances data = new Instances(new BufferedReader(new FileReader("data/titanic2_pre.arff")));
		CSVLoader loader = new CSVLoader();
		loader.setSource(new File("data/titanic2_pre.csv"));
		Instances data = loader.getDataSet(); // arff 형식으로 변환해서 가지고 온다.
//		System.out.println(data);
		
		// 모델을 읽어와서, test데이터에 있는 것 꺼내서 검증해보자.
		Classifier model = (Classifier) SerializationHelper.read("model/titanic_rf.model");
		
		// 1. Attribute리스트를 만들자.
		ArrayList attributes = new ArrayList<>();
		
		// 2. attributes리스트 만들어서 Instances객체에 셋팅
		Enumeration<Attribute> attr_list = data.enumerateAttributes();
//		System.out.println(attr_list);
		// 목록이 계속 있니? 물어보고 true이면 하나씩 attribute를 꺼내서, arraylist에 옮기자.
		// hasMoreElements() : 목록 중에 다음 항목(element, 요소)가 있는지 체크
		// nextElement() : 목록 중에 하나의 항목을 꺼내오자
		// attributes.add(항목)
		while (attr_list.hasMoreElements()) {
			attributes.add(attr_list.nextElement());
		}
		System.out.println(attributes);
		
		// 3. arff를 나타내는 Instances객체를 만들자.
		Instances instances = new Instances("test", attributes, 0);
		// target(분류할 대상, 분류할 항목, 정답)이 되는 인덱스를 설정
		instances.setClassIndex(instances.numAttributes() - 1);
		
		// 4. 분류할 데이터의 값들을 double[]에 넣어주자.
		double[] values = new double[7];
		Scanner sc = new Scanner(System.in);
		System.out.print("여자여부(틀리면 0, 맞으면 1)>> ");
		values[0] = sc.nextDouble();
		System.out.print("나이>> ");
		values[1] = sc.nextDouble();
		System.out.print("같이 탄 형제자매수>> ");
		values[2] = sc.nextDouble();
		System.out.print("요금>> ");
		values[3] = sc.nextDouble();
		System.out.print("3등급여부(틀리면 0, 맞으면 1)>> ");
		values[4] = sc.nextDouble();
		System.out.print("2등급여부(틀리면 0, 맞으면 1)>> ");
		values[5] = sc.nextDouble();
		System.out.print("1등급여부(틀리면 0, 맞으면 1)>> ");
		values[6] = sc.nextDouble();
		sc.close(); // stream을 close(자원해제)
		instances.add(new DenseInstance(1, values));
		
		System.out.println("=== 여기까지 만든 arff(instances) 확인 ===");
		System.out.println(instances);
		
		// 5. read해온 model로 위에서 만든 사람을 분류해보자.
		// 분류기(classfier), 모델, 학습기
		double result = model.classifyInstance(instances.firstInstance());
		System.out.println("분류기의 결과>> " + result);
		
		if (result != 0) {
			System.out.println("yes");
		} else {
			System.out.println("no");
		}
		System.out.println("========================================");
		
		String[] yes = {
				"또 다른 여행을 가자",
				"집에서 다시는 안나오겠어",
				"파티를 열자",
				"바다는 정말 멀고 깊더군... 깊은 깨달음..."
		};
		
		String[] no = {
				"다음 생에는...",
				"다음 생에는 비행기를 타고 여행을 하겠어...",
				"바다 수영을 꼭 배워야겠어...",
				"이번 생 모두 파이팅...!"
		};
		
		Random r = new Random();
		if (result != 0) {
			System.out.println("생존한 경우 추천>> " + yes[r.nextInt(4)]);
		} else {
			System.out.println("생존하지 않은 경우 추천>> " + no[r.nextInt(4)]);
		}
	}

}
