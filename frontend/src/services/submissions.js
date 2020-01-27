import axios from "axios";

const instance = axios.create({
  baseURL: "" // Insert here backend env URL
});

const formatDate = date => {
  const month = date.getMonth() + 1;
  const day = date.getDate();
  return `${date.getFullYear()}-${month < 10 ? `0${month}` : month}-${
    day < 10 ? `0${day}` : day
  }`;
};

export const submitPurchase = (amount, date) => {
  return instance
    .post("/api/submissions", {
      submission: {
        amount,
        date: formatDate(date)
      }
    })
    .then(response => {
      const { data } = response;
      return data.submission;
    });
};

export const getSubmissions = () => {
  return instance.get("/api/submissions").then(response => {
    const { data } = response;
    return data.report;
  });
};

export const getSubmission = id => {
  return instance.get(`/api/submissions/${id}`).then(response => {
    const { data } = response;
    return data.submission;
  });
};
