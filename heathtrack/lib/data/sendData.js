const fs = require("fs");
const data = require("./data.json");

function sendObjectToServer(objectToSend) {
  objectToSend.timestamp = Date.now();
  fetch("http://localhost:3000/api/heath-data", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify(objectToSend),
  })
    .then((response) => {
      if (!response.ok) {
        console.error("Error sending data:", response.status);
      } else {
        console.log("Data sent successfully!");
      }
    })
    .catch((error) => {
      console.error("Error sending data:", error);
    });
}

function sendObjectsPeriodically() {
  let index = 0;
  const interval = 20 * 1000; // 30 phút

  const sendNextObject = () => {
    if (index < data.length) {
      sendObjectToServer(data[index]);
      console.log(data[index]);
      index++;
    } else {
      clearInterval(timer);
      console.log("Đã gửi hết các đối tượng trong mảng.");
    }
  };

  sendNextObject(); // Gửi đối tượng đầu tiên ngay khi bắt đầu
  const timer = setInterval(sendNextObject, interval);
}

sendObjectsPeriodically();
