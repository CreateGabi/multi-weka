package base;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.util.Random;

import weka.classifiers.Evaluation;
import weka.classifiers.trees.RandomForest;
import weka.core.Instances;
import weka.core.SerializationHelper;
import weka.core.converters.CSVLoader;

public class WekaTest_titanic_3 {

	public static void main(String[] args) throws Exception {
		// 1. 데이터 로딩(수집)
//		Instances data = new Instances(new BufferedReader(new FileReader("data/titanic2_pre.arff")));
		CSVLoader loader = new CSVLoader();
		loader.setSource(new File("data/titanic2_pre.csv"));
		Instances data = loader.getDataSet(); // arff 형식으로 변환해서 가지고 온다.
//		System.out.println(data);
		
		Instances train = data.trainCV(5, 0, new Random(100));
		Instances test = data.testCV(5, 0);
		
		// 모델을 읽어와서, test데이터에 있는 것 꺼내서 검증해보자.
		Classifier model =  SerializationHelper.read("model/titanic_rf.model");
		
		// 나의 데이터를 넣어서, 내가 타이타닉호에 탔을 때, 죽었을지 살았을지 판단해보자.
		
	}

}
