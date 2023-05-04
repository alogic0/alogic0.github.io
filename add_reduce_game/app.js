const app = Vue.createApp({
  data() {
    return {
      goal: 1,
      result: 0,
      addCounter: 0,
      reduceCounter: 0,
      addNum: 3,
      reduceNum: 7,
    };
  },
  methods: {
    clearCounters() {
      this.result = 0;
      this.addCounter = 0;
      this.reduceCounter = 0;
    },
    reloadGame() {
      this.clearCounters();
      this.goal = 1;
      this.addNum = 3;
      this.reduceNum = 7;
    },
    setRandom() {
      this.clearCounters();
      this.goal = Math.floor(Math.random() * 70) + 1;
    },
    gameOver() {
      this.goal = "You won!";
    },
    checkGameOver() {
      if (this.result == this.goal) {
        this.gameOver();
      }
    },
    add() {
      addNum = parseInt(this.addNum);
      this.result += addNum;
      this.addCounter += 1;
      this.checkGameOver();
    },
    reduce() {
      reduceNum = parseInt(this.reduceNum);
      // only positive result
      if (this.result >= reduceNum) {
        this.result -= this.reduceNum;
        this.reduceCounter += 1;
        this.checkGameOver();
      }
    },
  },
});

app.mount("#events");
