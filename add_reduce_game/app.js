const app = Vue.createApp({
  data() {
    return {
      goal: 1,
      result: 0,
      addCounter: 0,
      reduceCounter: 0
    };
  },
  methods: {
    gameOver() {
      this.goal = 'You won!';
    },
    checkGameOver() {
      if (this.result == this.goal) {
        this.gameOver();
      }
    },
    add(num) {
      this.result += num;
      this.addCounter += 1;
      this.checkGameOver();
    },
    reduce(num) {
      this.result -= num;
      this.reduceCounter += 1;
      this.checkGameOver();
    }
  }
});

app.mount('#events');
