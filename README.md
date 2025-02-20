# ETL Pipeline in OCaml

## Overview

This project implements an ETL (Extract, Transform, Load) pipeline using OCaml, a functional programming language known for its strong type system and immutability features. The pipeline processes data from two CSV files representing orders and order items, applies necessary transformations, and outputs a consolidated CSV file with aggregated data. The final output is designed to feed into a business intelligence dashboard, providing insights into total amounts and taxes for orders based on specific criteria such as status and origin.

## Project Goals

The primary goal of this project is to demonstrate the effectiveness of functional programming in building scalable and maintainable ETL processes. By leveraging OCaml's functional paradigms—such as higher-order functions, immutability, and pure functions—the project aims to handle data transformations efficiently, especially in scenarios involving large datasets.

## Key Features

- **Data Extraction**: Reads data from CSV files containing order and order item details.
- **Data Transformation**: Applies transformations using functional programming techniques like `map`, `reduce`, and `filter` to calculate total amounts and taxes for each order.
- **Data Loading**: Outputs the transformed data into a new CSV file, ready for use in business intelligence tools.
- **Parameterization**: Allows filtering of orders based on status and origin, providing flexibility in the data output.

## Use Cases

- **Business Intelligence**: Enhances decision-making by providing aggregated data views.
- **Machine Learning Pipelines**: Prepares and structures data for machine learning models.
- **Data Engineering**: Demonstrates a scalable approach to data processing tasks.
