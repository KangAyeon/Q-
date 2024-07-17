namespace QuantumRandomNumberGenerator {
    open Microsoft.Quantum.Convert;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Math;


    @EntryPoint() // 프로그램의 EntryPoint. Run 누르면 작동한다. (GenerateRandomNumberInRange 실행 > 내부의 GenerateRandomBit 실행 > 얻은 값이 max보다 크면 다시 실행 > Good이라면 출력하고 종료.)
    operation Main() : Int {
        let max = 10000; // 변수 let지시문으로 선언.. 때려 죽어도 안 바뀜
        Message($"Sampling a random number between 0 and {max}: "); // {변수}는 따옴표 본격적으로 개무시함

        // Generate random number in the 0..max range. (0부터 (8번 줄에서 설정한)max값까지의 난수를 생성(GenerateRandomNumberInRange))
        return GenerateRandomNumberInRange(max);
    }

    /// Generates a random number between 0 and `max`. (11번 줄에서 사용될 난수(0~max 사이의 값) 생성 함수 설정)
    /// ★큐비트를 활용한 난수생성기 구현 함수★
    operation GenerateRandomNumberInRange(max : Int) : Int {
        // Determine the number of bits needed to represent `max` and store it ((8번 줄에서 설정한)max값을 int로 저장.)
        // in the `nBits` variable. Then generate `nBits` random bits which will (nBit변수는 변할수 있는 수ㅋㅋ)
        // represent the generated random number.
        // (솔직히 영어 뭔소린지 모르겠어서 코드 보고 해석해봄 <=> 영어하고 말이 안 맞을 수 있음)
        mutable bits = []; // bit는 변경가능 변수.. set지시문으로 값 변경 가능
        let nBits = BitSizeI(max); // nbit도 바뀔수 있음ㅋㅋ 같은 let이지만 이놈은 바뀜 why? BitSizeI() 쏘 굿굿
        for idxBit in 1..nBits {
            set bits += [GenerateRandomBit()]; // 아래 문단에서 정의한 함수임. 큐비트를 얻어올거임
        }
        let sample = ResultArrayAsInt(bits); // ResultArrayAsInt는 2번 줄에서 얻은 내장함수?임 bits문자열을 정수로 받아줌

        // Return random number if it is within the requested range.
        // Generate it again if it is outside the range.
        // 8번 줄에서 얻은 max값보다 나온 값이 더 크면 다시 이 함수 실행. (범위 이미 지정해준거 아닌가? 그럴 수가 있나?)
        return sample > max ? GenerateRandomNumberInRange(max) | sample;
    }
    
    /// ★큐비트 구현 함수★
    operation GenerateRandomBit() : Result {
        // Allocate a qubit. (큐비트 설정하기 Qubit 내장함수를 변수 q에 지정해 줄거임)
        use q = Qubit();

        // Set the qubit into superposition of 0 and 1 using the Hadamard operation
        // (큐비트를 동일한 중첩에 배치(H(내장함순가 봄))하고 작동하면 0 or 1을 얻음(큐비트도 비트이기 때문))
        H(q);

        // At this point the qubit `q` has 50% chance of being measured in the
        // |0〉 state and 50% chance of being measured in the |1〉 state.
        // Measure the qubit value using the `M` operation, and store the
        // measurement value in the `result` variable.
        // (큐비트가 가질 수 있는 값은 0 or 1이니까 0, 1의 각각 나올 확률은 50%임. result에 측정한(M(내장함순가 봄)) 값을 넣어줌)
        let result = M(q);

        // Reset qubit to the |0〉 state.
        // Qubits must be in the |0〉 state by the time they are released.
        // 큐비트를 다시 0으로 돌려놓음. (기본값이 0인가 봄)
        Reset(q);

        // Return the result of the measurement.
        // 46번 줄에서 얻은 result를 가짐 이제 GenerateRandomBit쓰면 이 result가 나오는거임(이거 위의 문단에서 사용함)
        return result;
    }
}