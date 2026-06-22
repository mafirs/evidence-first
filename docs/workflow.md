# Workflow

This workflow has five stages.

## 1. Diagnose

Read the relevant code before making claims. Every key claim must cite a file and line number or be marked as an assumption.

## 2. Route

Compare possible routes before writing implementation details. The goal is to choose the right mechanism, not to write code early.

## 3. Plan

Write a surgical implementation plan with diffs, evidence, business impact, regression checks, and explicit non-goals. Do not edit code in this stage.

## 4. Execute

Apply only the confirmed diff. Do not refactor, reformat, rename, or fix unrelated issues. If the plan no longer matches the current code, stop and report the conflict.

## 5. Review

Review the final plan or another AI's critique. Accept only evidence-backed findings. Archive low-value or speculative comments.
