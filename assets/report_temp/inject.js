if (typeof runFlag === "undefined") {

var runFlag = true;
console.info('Initializing report/inject.js on:', location.href);

// templates
const userName = '{{username}}'.trim();
const css = `{{injectCSS}}`.trim();

// const prefix = 'http://xgfy.sit.edu.cn/h5/';
// const routes = [ 'guide', 'news', 'index', 'studentReport', 'jksb', 'yimiaon', 'view' ];

const getRoute = name => name === 'guide' ? '#/' : `#/pages/index/${name}`;

const route = {
  is: name => location.hash === getRoute(name),
  go: name => location.assign(getRoute(name))
};

const click = (selector, text) => {
  const element = document.querySelector(selector);
  element !== null &&
  element.textContent === text &&
  element.click();
}

// visibilitychange
Document.prototype.addEventListener = new Proxy(
  Document.prototype.addEventListener, {
    apply: (target, _this, args) => (
      args[0] === 'visibilitychange'
      ? undefined
      : Reflect.apply(target, _this, args)
    )
  }
);

// load
window.addEventListener('load', () => {

  // login
  if (route.is('guide') && userName !== '') {
    localStorage.setItem('userInfo', JSON.stringify({ code: userName, ayz: '1893427200000unifri' }));
    localStorage.setItem('logcurrent', '1893427200000');
    localStorage.setItem('version', '3.0');
    localStorage.setItem('loginIn', '3');
    // localStorage.setItem('isApp', '1');
    route.go('index');
  }

  // allowReport
  const userInfo = JSON.parse(localStorage.getItem('userInfo'));
  if ( // if userInfo matches { allowReport: 0 }
    typeof userInfo === 'object' &&
    userInfo !== null &&
    userInfo.allowReport === 0
  ) {
    userInfo.allowReport = 1;
    localStorage.setItem('userInfo', JSON.stringify(userInfo));
  }

  // checklist
  const checkChecklist = () => (
    route.is('jksb') &&
    click('.checklist-box', '本人承诺:上述填写内容真实、准确、无误！')
  );

  checkChecklist();

  uni.navigateTo = new Proxy(
    uni.navigateTo, {
      apply: (target, _this, args) => {
        setTimeout(checkChecklist, 200);
        return Reflect.apply(target, _this, args);
      }
    }
  );

  // redirect
  uni.redirectTo = new Proxy(
    uni.navigateTo, {
      apply: (target, _this, args) => (
        route.is('jksb') &&
        args[0]?.url === './index'
        ? click('.nav .cu-item[data-id=1]', '历史')
        : Reflect.apply(target, _this, args)
      )
    }
  );

  // css
  const style = document.head.appendChild(document.createElement('style'));
  style.textContent = css;

});


}
