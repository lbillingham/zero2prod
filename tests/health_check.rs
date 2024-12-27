use std::net::TcpListener;

fn spawn_app() -> String {
    let listener = TcpListener::bind("127.0.0.1:0").expect("Failed to bind random port.");
    let port = listener.local_addr().unwrap().port();
    let server = zero2prod::startup::run(listener).expect("Failed to bind address.");
    let _ = tokio::spawn(server);
    format!("http://127.0.0.1:{}", port)
}

#[tokio::test]
async fn health_check_works() {
    let address = spawn_app();
    let client = reqwest::Client::new();

    let response = client
        .get(&format!("{address}/health_check"))
        .send()
        .await
        .expect("Failed to exexute request.");

    assert!(response.status().is_success());
    assert_eq!(Some(0), response.content_length())
}

#[tokio::test]
async fn subscribe_returns_a_200_when_form_data_valid_and_have_extra_fields() {
    let app_address = spawn_app();
    let client = reqwest::Client::new();

    let body = "this_field_is_extra=True&name=le%20guin&email=ursula_le_guin%40gmail.com";
    let response = client
        .post(&format!("{}/subscriptions", app_address))
        .header("Content-Type", "application/x-www-form-urlencoded")
        .body(body)
        .send()
        .await
        .expect("Failed to execute request.");

    assert_eq!(200, response.status().as_u16())
}

#[tokio::test]
async fn subscribe_returns_a_200_when_form_data_valid() {
    let app_address = spawn_app();
    let client = reqwest::Client::new();

    let body = "name=le%20guin&email=ursula_le_guin%40gmail.com";
    let response = client
        .post(&format!("{}/subscriptions", app_address))
        .header("Content-Type", "application/x-www-form-urlencoded")
        .body(body)
        .send()
        .await
        .expect("Failed to execute request.");

    assert_eq!(200, response.status().as_u16())
}

#[tokio::test]
async fn subscribe_returns_a_400_when_form_data_missing() {
    let app_address = spawn_app();
    let client = reqwest::Client::new();

    let test_cases = vec![
        ("name=le%20guin", "email field is missing"),
        ("email=ursula_le_guin%40gmail.com", "name field is missing"),
        ("", "both name and email fields are missing"),
    ];

    for (invalid_body, error_message) in test_cases {
        let response = client
            .post(&format!("{}/subscriptions", app_address))
            .header("Content-Type", "application/x-www-form-urlencoded")
            .body(invalid_body)
            .send()
            .await
            .expect("Failed to execute request.");

        assert_eq!(
            400,
            response.status().as_u16(),
            // Additional customised error message on test failure
            "The API did not fail with 400 Bad Request when the payload was {}.",
            error_message
        );
    }
}
