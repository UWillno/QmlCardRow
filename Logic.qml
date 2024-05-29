import QtQuick

Item {
    // 范围内取随机数
    function generateRandomNumber(min, max) {
        return Math.floor(Math.random() * (max - min + 1)) + min;
    }
    // 取随机数时排除某些数
    function getRandomExcluding(min, max, exclusions) {
        const exclusionSet = new Set(exclusions);
        let randomNumber;

        do {
            randomNumber = generateRandomNumber(min, max);
        } while (exclusionSet.has(randomNumber));

        return randomNumber;
    }
    // 取 QGradient 的预设值
    function getRandomGradient(){
        return getRandomExcluding(1,180,[27, 39, 40, 45, 71, 74, 105, 111, 119, 130, 135, 141])
    }
}
